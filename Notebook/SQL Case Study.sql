-- 
select * from emp


1. Use CTE to display list of managers from EMP table who has atleast one person reporting to them

with mgr_with_reporting as
(select mgr, count(empno) as ct from emp group by mgr)
select * from  emp a
inner join mgr_with_reporting m on a.empno = m.mgr

2.

select ename, job, case
						when DATEDIFF(year, hiredate, getdate()) >40 then 'yes'
						Else 'No'
				   End as promotion_eligible
				 from emp
3.

create or alter function emp_exp (@hiredate date)
Returns Int
as 
	Begin
		Declare @exp int;
		Set @exp = year(getdate()) - year(@hiredate)
	Return @exp
	End
4.

create or alter function emp_tier(@hiredate date)
Returns varchar(10)
as 
	Begin
		Declare @tier varchar(10)
		Set @tier=
			Case
				when dbo.emp_exp(@hiredate) <20 then 'Tier 4'
				when dbo.emp_exp(@hiredate) between 20 and 29 then 'Tier 3'
				when dbo.emp_exp(@hiredate) between 30 and 39 then 'Tier 2'
				Else 'Tier 1'
			End
		Return @tier
	End
5. scaler valued function

create or ALter function comm_hike(@empno INT)
Returns float
as
	Begin
		Declare @vcomm float;
		Select @vcomm = comm from emp where empno = @empno
			If @vcomm is NULL or @vcomm =0
				Begin
					Set @vcomm=200
				End
			Else
				Begin
				 Set @vcomm = @vcomm*1.1
				End
		Return @vcomm
	End
	

select *, dbo.comm_hike(empno) as comm_hike from emp

6. Table valued function
create or alter function Empdetails(@deptno int)
Returns Table
	Return Select * from emp where deptno = @deptno

select * from dbo.Emp_details(10)

7. Stored procedures

create or alter procedure comm_hike_sp (@empno INT)
as
	Begin
		Declare @vcomm Float;
		Select @vcomm=comm from emp where empno = @empno
		If @vcomm is NULL or @vcomm =0
			Begin
				Update emp set comm = 200 where empno = @empno
			End
		Else
			Begin
				Update emp set comm = comm*1.1 where empno = @empno
			End
	End

Exec comm_hike_SP 5678
select * from emp

8.
select * from customer
create function age_band(@vDOB datetime)
Returns VARCHAR(10)
as 
	Begin
		Declare @vageband varchar(10),
				@vAGE INT;
		Set @vAGE = year(getdate()) - year(vDOB)
		set @vageband=
		Case	
			When @vAGE between 0 and 9 then '0-9'
			When @vAGE between 10 and 19 then '10-19'
			When @vAGE between 20 and 29 then '20-29'
			When @vAGE between 30 and 39 then '30-39'
			When @vAGE between 40 and 49 then '40-49'
			When @vAGE between 50 and 59 then '50-59'
			When @vAGE between 60 and 69 then '60-69'
			When @vAGE between 70 and 79 then '70-79'
			When @vAGE between 80 and 89 then '80-89'
			Else '90-99'
		End
		Return @vageband
	End

select dbo.age_band([Date of Birth]) as age_band, count(*) as no_of_customers from customer group by dbo.age_band([Date of Birth])

9.
Alter table emp ADD Newjob varchar(10)

Select * from emp

create or Alter procedure sp_promotion (@empno int)
as
	Begin
		Declare @hiredate date,
				@deptno int,
				@job int,
				@Newjob varchar(20)
		Select @hiredate = hiredate from emp where empno = @empno
		Select @deptno = deptno from emp where empno = @empno
		Select @job  = job from emp where empno = @empno
		If @job <> 'President' and DATEDIFF(year, @hiredate, getdate())>40
			Begin
				set @Newjob=
					Case 
						When @deptno = 10 then 'VP OPS'
						when @deptno = 20 then 'VP RES'
						when @deptno = 30 then 'VP SALES'
						Else 'VP ACC'
					End
					Update Emp set newjob = @newjob where empno = @empno
			End
		Else
			Begin
				Print concat ('The employee', @empno, 'is not eligible for promotion')
			End
	End

--Loops and Cursors
10.

Declare @count int = 10
Begin
	While @count>0
		Begin
			print concat ('The output number is', @count)
			Set @count = @count -1
		End
End

Various stages of a cursor lifecycle

Declare
	Open
	Fetch -- it fetches the data from first row in the cursor
	while @@FETCH_STATUS =0 -- flag to 0 is any record in the cursor exists, or else its set to 1
	Begin
		All processing will be done here
	Fetch -- it fetches the data from next available row in the cursor
	End
	Close
Deallocate cursor

11.

Declare @Empno int,
		@Ename varchar(15);
Declare Empcur cursor
		for select Empno, Ename from emp where deptno=10

		Open Empcur
		Fetch Empcur into @Empno, @Ename
		While @@FETCH_STATUS=0
		Begin
			print concat ('The Empno ', @Empno, ' has the name ', @Ename)
			Fetch Empcur into @Empno, @Ename
		End
		Close Empcur;
		Deallocate Empcur;

12.

create or alter procedure comm_hike_sp_Cur
as
	Begin
		Declare @comm Float,
				@Empno INT;
		Declare Empcur cursor
		for Select Empno, comm from emp
		Open Empcur
		Fetch Empcur into @Empno, @comm
		While @@FETCH_STATUS=0
		Begin
			If @comm is NULL or @comm =0
				Begin
					Update emp set comm = 200 where empno = @empno
				End
			Else
				Begin
					Update emp set comm = comm*1.1 where empno = @empno
				End
			Fetch Empcur into @Empno, @comm
		End
		Close Empcur
		Deallocate Empcur
	End

Exec comm_hike_sp_Cur

13. 
create or Alter procedure sp_promotion (@deptno int)
as
	Begin
		Declare @hiredate date,
				@Empno int,
				@job int,
				@Newjob varchar(20)
		Declare Empcur cursor
				for Select Empno, hiredate, job from Emp where deptno=@deptno
		Open Empcur
		Fetch Empcur into @Empno, @hiredate, @job
		While @@FETCH_STATUS=0
		Begin
			If @job <> 'President' and DATEDIFF(year, @hiredate, getdate())>40
				Begin
					set @Newjob=
						Case 
							When @deptno = 10 then 'VP OPS'
							when @deptno = 20 then 'VP RES'
							when @deptno = 30 then 'VP SALES'
							Else 'VP ACC'
						End
						Update Emp set newjob = @newjob where empno = @empno
				End
			Else
				Begin
					Print concat ('The employee', @empno, 'is not eligible for promotion')
				End
			Fetch Empcur into @Empno, @hiredate, @job
		End
		Close Empcur
		Deallocate Empcur
	End

14.

create or Alter procedure sp_promotion (@empno int)
as
	Begin
		Declare @hiredate date,
				@deptno int,
				@job int,
				@Newjob varchar(20)
		Select @hiredate = hiredate from emp where empno = @empno
		Select @deptno = deptno from emp where empno = @empno
		Select @job  = job from emp where empno = @empno
		If @job IS NOT NULL
			Begin
				If @job <> 'President' and DATEDIFF(year, @hiredate, getdate())>40
					Begin
						set @Newjob=
							Case 
								When @deptno = 10 then 'VP OPS'
								when @deptno = 20 then 'VP RES'
								when @deptno = 30 then 'VP SALES'
								Else 'VP ACC'
							End
							If @job = @Newjob
								Begin
									print concat ('The employee', @empno,' cannot be upgraded to same position')
								End
							Else
								Begin
									Update Emp set newjob = @newjob where empno = @empno
								End
					End
				Else
					Begin
						Print concat ('The employee', @empno, 'is not eligible for promotion')
					End
			End
		Else
		Begin
			Print concat ('The employee', @empno, 'is invalid')
		End
	End

15. --SQL Triggers

select * into emp_l from EMP
truncate table emp_l
select * from emp_l
alter table emp_l add deletedon date, deletedby varchar(15)
create trigger trg_dlt on EMP
after delete,update
as 
	Insert into dbo.emp_log (empno, ename, job, mgr, hiredate, sal, comm, deptno, Newjob, deletedon, deletedby)
	Select empno, ename, job, mgr, hiredate, sal, comm, deptno, Newjob, getdate(), user_name() from deleted

Select * from emp_log

16. --Exception and Error Handling

Print 'Before Try Block'
Begin Try
	Print 'Inside try block first Line'
	Insert Into emp values (8976, 'Miller','CLERK',7782, '1982-01-23',1300, NULL, 10, NULL)
	Print 'Inside try block last line'
End Try

Begin Catch
	print 'Inside Catch block first line'
	print error_message()
	PRINT ERROR_NUMBER()
	Print Error_state()
	Print error_severity()
	print 'Inside Catch block last line'
End Catch
	print 'Outside Catch block End of code'

17.
Begin Try
	If (cast(getdate() as time) between cast('18:00:00' as time) and cast('23:55:00' as time))
		Begin
			Raiserror('You cannot run this code during non working hours',6,1)
		End
	Else
		Begin
			Exec comm_hike_sp
		End
End Try

Begin Catch
	Print Error_message()
	print Error_number()
	print Error_State()
	print Error_severity()
End Catch

18. Date of first purchase human


select * from customer

create or alter function epoch_converter (@DOFP int)
Returns datetime
as
	Begin
		Declare @epoch datetime;
		Set @epoch = cast(DATEadd(second, @DOFP,'1970-01-01 00:00:00' ) as datetime)
		
		Return @epoch
	End

alter table customer add date_of_first_purchase_human datetime

update Customer set [date_of_first_purchase_human] = dbo.epoch_converter([Date of First Purchase])


19.

insert into customer ([Customer ID],[Customer Name], [Date of Birth],[Marital Status],[Gender] , [Yearly Income])
values ('AR-12346', 'Mohammed Arif', '1991-09-21', 'M','M',120000)

create trigger new_order on OrdersNew
after insert
as
	Begin
		Declare @countOrders INT;
		Select @countOrders = count(*) from OrdersNew where [Customer ID] = (Select [Customer ID] from inserted)
		If @countOrders >1
			Begin
				print 'Existing customer booking order'
			End
		Else
			Begin
				print 'New customer booking order'
			End

	End

20.

create trigger dbo.new_order on OrdersNew
after insert
as
	Begin
		Declare @countOrders INT, @orderdate datetime, @customerid varchar(15);
		Select @countOrders = count(*) from OrdersNew where [Customer ID] = (Select [Customer ID] from inserted)
		select @customerid = [Customer ID] from inserted
		select @orderdate = [Order Date] from inserted
		If @countOrders =1
			Begin
				update customer set [date_of_first_purchase_human] = @orderdate where [Customer ID] = @customerid
			End
	End

insert into ordersnew ([Row ID],[Order Date] ,[Customer ID] )
values (23432, getdate(), 'AR-12346')

select * from Customer

update Customer set [date_of_first_purchase_human] = NULL

select * from OrdersNew

21.  Unpivot

select * from pivotsample

With Temp as
(Select year,
	Case
		When month in ('Jan', 'Feb', 'Mar') then 'Q1'
		When month in ('Apr', 'May', 'Jun') then 'Q2'
		When month in ('July', 'Aug', 'Sept') then 'Q3'
		Else 'Q4'
	End as quarter,
	month,
	sales
	from
		(Select Year, Jan, Feb, Mar, Apr, May, Jun, July, Aug, Sept, Oct, Nov, Dec from dbo.pivotsample) sal
		Unpivot
		(sales for month in (Jan, Feb, Mar, Apr, May, Jun, July, Aug, Sept, Oct, Nov, Dec)) as Temp)
Select sum(sales) as sum_of_sales , year, quarter 
from Temp
group by year, quarter

22.
Select * into sample_pivot
from
(Select year,
	Case
		When month in ('Jan', 'Feb', 'Mar') then 'Q1'
		When month in ('Apr', 'May', 'Jun') then 'Q2'
		When month in ('July', 'Aug', 'Sept') then 'Q3'
		Else 'Q4'
	End as quarter,
	month,
	sales
	from
		(Select Year, Jan, Feb, Mar, Apr, May, Jun, July, Aug, Sept, Oct, Nov, Dec from dbo.pivotsample) sal
		Unpivot
		(sales for month in (Jan, Feb, Mar, Apr, May, Jun, July, Aug, Sept, Oct, Nov, Dec)) as Temp)T

Select * from sample_pivot

23. Pivot
Select * from
(select year, month, sales from sample_pivot) sal
Pivot (sum(sales) for month in (Jan, Feb, Mar, Apr, May, Jun, July, Aug, Sept, Oct, Nov, Dec)) as Temp

24. Pivot without using pivot function
select
	year,
	sum(Case When month='Jan' then sales end) as Jan,
	sum(Case When month='Feb' then sales end) as Feb,
	sum(Case When month='Mar' then sales end) as Mar,
	sum(Case When month='Apr' then sales end) as Apr,
	sum(Case When month='May' then sales end) as May,
	sum(Case When month='Jun' then sales end) as Jun,
	sum(Case When month='July' then sales end) as July,
	sum(Case When month='Aug' then sales end) as Aug,
	sum(Case When month='Sept' then sales end) as Sept,
	sum(Case When month='Oct' then sales end) as Oct,
	sum(Case When month='Nov' then sales end) as Nov,
	sum(Case When month='Dec' then sales end) as Dec
	from sample_pivot
group by year;

25. UnPivot without using Unpivot function

select * from pivotsample

Select Year, 'Jan' as month, Jan as sales from pivotsample 
union all
Select Year, 'Feb' as month, Feb as sales from pivotsample 
union all
Select Year, 'Mar' as month, Mar as sales from pivotsample 
union all
Select Year, 'Apr' as month, Apr as sales from pivotsample 
union all
Select Year, 'May' as month, May as sales from pivotsample 
union all
Select Year, 'Jun' as month, Jun as sales from pivotsample 
union all
Select Year, 'July' as month, July as sales from pivotsample 
union all
Select Year, 'Aug' as month, Aug as sales from pivotsample 
union all
Select Year, 'Sept' as month, Sept as sales from pivotsample 
union all
Select Year, 'Oct' as month, Oct as sales from pivotsample 
union all
Select Year, 'Nov' as month, Nov as sales from pivotsample 
union all
Select Year, 'Dec' as month, Dec as sales from pivotsample 


26.
create trigger trg_multiple_managers on Employee
instead of Insert
as 
	Begin
		If Exists (Select 1 from Employee E join inserted I on E.EmpID=i.EmpID)
			Begin
				Raiserror ('You cannot enter two managers for one employee',16,1)
				Rollback Transaction
			End
		Else
			Begin
				Insert into Employee (EmpID, EmpName, ManagerName)
				Select EmpID, EmpName, ManagerName from Inserted
			End
	End