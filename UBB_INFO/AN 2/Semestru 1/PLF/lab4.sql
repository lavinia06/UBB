use DressStudio3

---------------------------------------views--------------------

go
create or alter view view_getStudios
as
	select * from Studios
go

create or alter view view_getModelsWithStudios
as
	select *
	from Models M inner join ModelsPerStudio MS on M.model_id = MS.model inner join Studios S on S.studio_id=MS.studio
go
 
 create or alter view view_getNrMetersInStudios
 as
	select MA.material_colour, sum(M.nr_meters) as Total_Meters
	from Studios S inner join MaterialsInStudios M on S.studio_id = M.studio inner join Materials MA on M.material = MA.material_id
	group by MA.material_colour
go

select * from [view_getStudios]

select * from [view_getModelsWithStudios]

select * from [view_getNrMetersInStudios]

------------------ utility -----------------


create or alter function uf_SplitIntoWords(@string varchar(1000), @delimiter varchar(5))
returns @Words table(word varchar(50))
as
begin
		
	declare @current varchar(50)
	declare @index int

	while CHARINDEX(@delimiter, @string) > 0
	begin
		
		select @index = CHARINDEX(@delimiter, @string)
		select @current = SUBSTRING(@string, 1, @index - 1)
		
		select @string = SUBSTRING(@string, @index + 1, LEN(@string) - @index)

		insert into @Words
		select @current
	end

	if @string <> ''
	begin
		insert into @Words
		select @string
	end

	return
end
go


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
----------------------------------Creating the tests-----------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------


create or alter procedure usp_insertViews @viewList varchar(1000)
as
begin
	--use the SplitIntoWords function to get the view names in the Given_views
	declare @Given_views table(View_name varchar(50))
	insert into @Given_views
	select * 
	from uf_SplitIntoWords(@viewList, ',')
	declare @error_message varchar(100)
	declare @view_name varchar(50)

	-- Check if all the views are declared in the Database
	declare View_name_cursor cursor for
		select GV.View_name
		from @Given_views GV
	open View_name_cursor
	fetch View_name_cursor into @view_name
	while @@FETCH_STATUS = 0
	begin
		--check if the current view is exists in the DB
		if 0 = (select count(*) from sys.views st where st.name = @view_name)
		begin
			set @error_message = concat('Error: ', @view_name, ' is not defined!')
			raiserror(@error_message, 16, 1)
			return
		end

		fetch next from View_name_cursor into @view_name
	end
	close View_name_cursor
	deallocate View_name_cursor

	--If all views are declared in the Database we'll add in the Views table only the names that aren't allready inside
	insert into Views
	select GV.View_name
	from @Given_views GV
	where 0 = ( select count(*)
				from Views V
				where V.Name = GV.View_name)
end
go



create or alter procedure usp_insertTables @tableList varchar(1000)
as
begin
	
	--use the SplitIntoWords function to get the table names in the Given_tables
	declare @Given_tables table(Table_name varchar(50))
	insert into @Given_tables
	select * 
	from uf_SplitIntoWords(@tableList, ',')
	declare @error_message varchar(100)
	declare @table_name varchar(50)

	-- Check if all the tables are declared in the Database
	declare Table_name_cursor cursor for
		select GT.Table_name
		from @Given_tables GT
	open Table_name_cursor
	fetch Table_name_cursor into @table_name
	while @@FETCH_STATUS = 0
	begin
		--check if the current table exists in the DB
		if 0 = (select count(*) from sys.tables st where st.name = @table_name)
		begin
			set @error_message = concat('Error: ', @table_name, ' is not defined!')
			raiserror(@error_message, 16, 1)
			return
		end

		fetch next from Table_name_cursor into @table_name
	end
	close Table_name_cursor
	deallocate Table_name_cursor

	--If all tables are declared in the Database we'll add in the Tables table only the names that aren't allready inside
	insert into Tables
	select GT.Table_name
	from @Given_tables GT
	where 0 = ( select count(*)
				from Tables T
				where T.Name = GT.Table_name)
end
go



create or alter procedure usp_insertTest @test_name varchar(50), @corespondingId int output
as
begin

	declare @error_message varchar

	if 0 <> (select count(*) from Tests T where T.Name = @test_name)
	begin
		set @error_message = concat('Error: ', @test_name, ' is already defined!')
		raiserror(@error_message, 16, 1)
		return
	end

	insert into Tests
	select @test_name
	--get the id of the inserted test
	set @corespondingId = @@IDENTITY
end
go



create or alter procedure usp_link_views_to_test @test_id int, @view_list varchar(1000)
as
begin
	--use the SplitIntoWords function to get the view names in the Given_views
	declare @Given_views table(view_name varchar(50))
	insert into @Given_views
	select * 
	from uf_SplitIntoWords(@view_list, ',')

	declare @view_name varchar(50)
	declare @view_id int

	declare View_name_cursor cursor for
		select GV.view_name
		from @Given_views GV
	open View_name_cursor
	fetch View_name_cursor into @view_name
	while @@FETCH_STATUS = 0
	begin
		--get the coresponding id for the current view
		select @view_id = V.viewID 
		from Views V
		where V.Name = @view_name

		insert into TestViews
		values(@test_id, @view_id)

		fetch next from View_name_cursor into @view_name
	end
	close View_name_cursor
	deallocate View_name_cursor
end
go



create or alter procedure usp_link_tables_to_test @test_id int, @table_list varchar(1000), @number_of_rows int
as
begin
	--use the SplitIntoWords function to get the table names in the Given_tables
	declare @Given_tables table(Table_name varchar(50))
	insert into @Given_tables
	select * 
	from uf_SplitIntoWords(@table_list, ',')

	declare @table_name varchar(50)
	--We use the index variable to assign a position to each table
	declare @index int
	set @index = 1
	declare @table_id int

	declare Table_name_cursor cursor for
		select GT.Table_name
		from @Given_tables GT
	open Table_name_cursor
	fetch Table_name_cursor into @table_name
	while @@FETCH_STATUS = 0
	begin
		--get the coresponding id for the current table
		select @table_id = T.TableID 
		from Tables T
		where T.Name = @table_name

		insert into TestTables
		values(@test_id, @table_id, @number_of_rows, @index)

		set @index = @index + 1
		fetch next from Table_name_cursor into @table_name
	end
	close Table_name_cursor
	deallocate Table_name_cursor
end
go



create or alter procedure usp_create_new_test @test_name varchar(50), @table_string varchar(1000), @view_string varchar(1000), @number_of_rows int
as
begin

	declare @test_id int

	exec usp_insertTables @table_string
	if @@error <> 0
		return 

	exec usp_insertViews @view_string
	if @@error <> 0
		return 

	exec usp_insertTest @test_name, @corespondingId = @test_id output
	if @@error <> 0
		return 

	exec usp_link_tables_to_test @test_id, @table_string, @number_of_rows
	
	exec usp_link_views_to_test @test_id, @view_string

end
go


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
----------------------------------Running the tests------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------


create or alter procedure usp_delete_all_records @test_id int
as
begin
		declare @table_name varchar(50)
		declare @query varchar(100)

		declare Table_name_cursor cursor for
			select T.Name
			from TestTables TT inner join Tables T on TT.TableID = t.TableID
			where TT.TestID = @test_id
			order by TT.Position
		open Table_name_cursor
		fetch Table_name_cursor into @table_name
		while @@FETCH_STATUS = 0
		begin 
			set @query = CONCAT('detele from ', @table_name)
			exec(@query)
			fetch next from Table_name_cursor into @table_name
	    end
		close Table_name_cursor
		deallocate Table_name_cursor

	end
	go

	create or alter procedure usp_insert_one_row @table_name varchar(50), @unique_number int
as
begin
	
	declare @table_object_id int
	declare @column_name varchar(50)
	declare @is_identity bit
	declare @column_type varchar(50)
	declare @referenced_object_id int
	declare @referenced_column_id int
	declare @query varchar(150)
	declare @random_number int
	declare @random_string varchar(20)
	declare @refered_table_name varchar(50)
	declare @refered_column_name varchar(50)
	declare @random_date date
	declare @random_fk int
	declare @random_cnp varchar(13)

	select @table_object_id = ST.object_id
	from sys.tables ST
	where ST.name = @table_name

	declare Column_cursor cursor for
		select sc.name, sc.is_identity, st.name, sfk.referenced_object_id, sfk.referenced_column_id
		from (sys.columns sc inner join sys.types st on sc.system_type_id = st.system_type_id)
			 left join sys.foreign_key_columns sfk on (sfk.parent_object_id = @table_object_id and sc.column_id = sfk.parent_column_id)
		where sc.object_id = @table_object_id
		order by sc.column_id
	open Column_cursor
	fetch Column_cursor into @column_name, @is_identity, @column_type, @referenced_object_id, @referenced_column_id
	
	
	set @query = 'insert into ' + @table_name + ' values('
	while @@FETCH_STATUS = 0
	begin
		if @is_identity = 0
		begin
			if @referenced_object_id is NULL
			begin
				if @column_type = 'smallint'
				begin
					set @random_number = floor(rand()*100)
					set @query = @query + cast(@random_number as varchar)+ ','
				end
				if @column_type = 'int'
				begin
					set @random_number = floor(rand()*100000)
					--set @query = @query + cast(@random_number as varchar(10)) + ','
					set @query = @query + cast(@unique_number as varchar(10)) + ','
				end
				if @column_type = 'varchar'
				begin
					set @random_number = floor(rand()*1000)
					set @random_string = '''random' + cast(@unique_number as varchar) + ''''
					set @query = @query + @random_string + ','
				end
				if @column_type = 'char'--for my db they are always on length 13 because they are use to represent CNPs
				begin
					set @random_cnp = cast(@unique_number as varchar)
					while len(@random_cnp) < 13
					begin
						set @random_number = floor(rand()*10)
						set @random_cnp = @random_cnp + cast(@random_number as varchar)
					end
					set @random_number = floor(rand()*10000 + 100000)
					set @query = @query + '''' + @random_cnp + '''' + ','
				end
				if @column_type = 'date'
				begin
					set @random_date = cast(DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0) as date)
					set @query = @query + '''' + cast(@random_date as varchar) + '''' + ','
				end
			end
			else
			begin
				select @refered_table_name = ST.name, @refered_column_name = SC.name 
				from sys.tables ST inner join sys.columns SC on ST.object_id = SC.object_id
				where ST.object_id = @referenced_object_id and SC.column_id = @referenced_column_id

				if exists (select name from sys.tables where name = 'min_fk_table')
					drop table min_fk_table
				create table min_fk_table(fk int)
				exec('insert into min_fk_table select min( ' + @refered_column_name + ' ) from ' + @refered_table_name)
				set @random_fk = (select top 1 fk from min_fk_table) + @unique_number
				set @query = @query + cast(@random_fk as varchar) + ','
				--drop table min_fk_table
			end

		end

		fetch next from Column_cursor into @column_name, @is_identity, @column_type, @referenced_object_id, @referenced_column_id
	end
	set @query = SUBSTRING(@query, 1, len(@query)-1)
	set @query = @query + ')'
	print @query
	exec(@query)
	close Column_cursor
	deallocate Column_cursor
end
go






create or alter procedure usp_test_inserts @test_id int, @test_run_id int
as
begin
	
	declare @number_of_rows int
	declare @table_name varchar(50)
	declare @start_time datetime
	declare @end_time datetime
	declare @inserted_rows int
	declare @table_id int
	declare @unique_number int

	select  @number_of_rows = max(TT.NoOfRows)
	from TestTables TT
	where TT.TestID = @test_id
	group by TT.TestID

	declare Table_name_cursor cursor for
		select T.Name
		from TestTables TT inner join Tables T on TT.TableID = T.TableID
		where TT.TestID = @test_id
		order by TT.Position desc
	open Table_name_cursor
	fetch Table_name_cursor into @table_name

	while @@FETCH_STATUS = 0
	begin
		set @inserted_rows = 0
		set @start_time = SYSDATETIME()	
		set @unique_number = 0

		while @inserted_rows < @number_of_rows
		begin
			exec usp_insert_one_row @table_name, @unique_number
			set @inserted_rows = @inserted_rows + 1
			set @unique_number = @unique_number + 1
		end

		set @end_time = SYSDATETIME()
		
		select @table_id = T.TableID
		from Tables T
		where T.Name = @table_name
	
		insert into TestRunTables
		values(@test_run_id, @table_id, @start_time, @end_time)

		fetch next from Table_name_cursor into @table_name
	end

	close Table_name_cursor
	deallocate Table_name_cursor
end
go

create or alter procedure usp_test_tables @test_id int, @test_run_id int
as
begin
	exec usp_delete_all_records @test_id
	exec usp_test_inserts @test_id, @test_run_id
end
go

create or alter procedure usp_test_views @test_id int, @test_run_id int
as
begin

	declare @view_name varchar(50)
	declare @start_time datetime
	declare @end_time datetime
	declare @view_id int
	declare @query varchar(100)

	declare View_name_cursor cursor for
		select V.Name
		from Views V inner join TestViews TV on V.ViewID = TV.ViewID
		where TV.TestID = @test_id
	open View_name_cursor
	fetch View_name_cursor into @view_name
	
	while @@FETCH_STATUS = 0
	begin
		set @query = 'select * from ' + @view_name
		set @start_time = SYSDATETIME()
		exec(@query)
		set @end_time = SYSDATETIME()

		--get the view id
		select @view_id = V.ViewID
		from Views V 
		where V.Name = @view_name

		insert into TestRunViews
		values(@test_run_id, @view_id, @start_time, @end_time)

		fetch next from View_name_cursor into @view_name
	end

	close View_name_cursor
	deallocate View_name_cursor
end
go

create or alter procedure usp_run_test @test_name varchar(50)
as
begin
	--check if test exists
	if 0 = (select count(*) from Tests T where T.Name = @test_name)
	begin
		declare @error varchar(50)
		set @error = 'The test ' + @test_name + ' does not exist'
		raiserror(@error, 16, 1)
		return
	end

	declare @test_id int
	declare @test_run_id int
	declare @start_time datetime
	declare @end_time datetime

	select @test_id = T.TestID
	from Tests T
	where T.Name = @test_name

	insert into TestRuns(Description) values('Test run of the test: ' + @test_name)
	set @test_run_id = @@IDENTITY

	set @start_time = SYSDATETIME()
	exec usp_test_tables @test_id, @test_run_id
	exec usp_test_views @test_id, @test_run_id
	set @end_time = SYSDATETIME()

	update TestRuns
	set StartAt = @start_time, EndAt = @end_time
	where TestRunID = @test_run_id
end
go

select * from Studios
delete from ModelsPerStudio
delete from Models
delete from Materials
delete from Designers
delete from BrandDress

delete from TestTables
delete from TestViews
delete from Tests
delete from Views
delete from Tables
delete from TestRuns
delete from TestRunTables
delete from TestRunViews

exec usp_create_new_test 'Test1', 'Models,Designers,Materials,BrandDress,Materials', 'view_getModelsWithStudios,view_getStudios', 1000
--exec usp_create_new_test 'Test2', 'Member,Small_group,Churches', 'view_getMembers', 1000
exec usp_run_test 'Test1'
--exec usp_run_test 'Test2'

select * from Tests
select * from Views
select * from TestViews
select * from Tables
select * from TestTables
select * from TestRuns
select * from TestRunTables
select * from TestRunViews