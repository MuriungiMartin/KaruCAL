#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51466 "All Students"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/All Students.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting(Programme,Stage) where("Cust Exist"=filter(>0));
            RequestFilterFields = "Settlement Type","Registration Date",Programme,"Academic Year","Semester Filter","Intake Code",Stage,"Programme Exam Category","Student Status",Faculty,Balance;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Cust_ID;Cust."ID No")
            {
            }
            column(USERID;UserId)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Programme_CourseRegistration;"ACA-Course Registration".Programme)
            {
            }
            column(Course_Registration__Course_Registration___Academic_Year_;"ACA-Course Registration"."Academic Year")
            {
            }
            column(Course_Registration__Course_Registration__Faculty;Faculty)
            {
            }
            column(Programme_______ProgName;Programme+' - '+ProgName)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Settlement_Type_;"Settlement Type")
            {
            }
            column(Course_Registration_Gender;Gender)
            {
            }
            column(CustName;CustName)
            {
            }
            column(NCount;NCount)
            {
            }
            column(Course_Registration__Course_Registration__Stage;"ACA-Course Registration".Stage)
            {
            }
            column(EmptyString;'_____________________')
            {
            }
            column(EmptyString_Control1102755003;'_____________________')
            {
            }
            column(TCount;TCount)
            {
            }
            column(MCount;MCount)
            {
            }
            column(FCount;FCount)
            {
            }
            column(IBCount;IBCount)
            {
            }
            column(SSCount;SSCount)
            {
            }
            column(JCount;JCount)
            {
            }
            column(Enrollment_Details__All_StudentsCaption;Enrollment_Details__All_StudentsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Academic_Year_Caption;Academic_Year_CaptionLbl)
            {
            }
            column(FacultyCaption;FacultyCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Settlement_Type_Caption;FieldCaption("Settlement Type"))
            {
            }
            column(Course_Registration_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Student_NameCaption;Student_NameCaptionLbl)
            {
            }
            column(YearCaption;YearCaptionLbl)
            {
            }
            column(SignCaption;SignCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Total_Students_Caption;Total_Students_CaptionLbl)
            {
            }
            column(Total_Male_Caption;Total_Male_CaptionLbl)
            {
            }
            column(Total_Female_Caption;Total_Female_CaptionLbl)
            {
            }
            column(Total_IB_Caption;Total_IB_CaptionLbl)
            {
            }
            column(Total_SSP_Caption;Total_SSP_CaptionLbl)
            {
            }
            column(Total_JAB_Caption;Total_JAB_CaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            column(status;"ACA-Course Registration".Status)
            {
                OptionCaption = 'Registration,Current,Alumni,Dropped Out,Defered,Suspended,Expulsion,Discontinued,Deferred,Deceased,Transferred,Disciplinary,Unknown,Completed not graduated,Graduated no Certificates,Graduated with Certificate,New Admission,Incomplete';
                OptionMembers = Registration,Current,Alumni,"Dropped Out",Defered,Suspended,Expulsion,Discontinued,Deferred,Deceased,Transferred,Disciplinary,Unknown,"Completed not graduated","Graduated no Certificates","Graduated with Certificate","New Admission",Incomplete;
            }
            column(UnitsTaken;"ACA-Course Registration"."Units Taken")
            {
            }
            column(Balance;"ACA-Course Registration".Balance)
            {
            }
            column(Phone;Cust."Phone No.")
            {
            }
            column(Names;Cust.Name)
            {
            }
            column(School;Faculty)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 cust2.Reset;
                 cust2.SetRange("No.","ACA-Course Registration"."Student No.");
                 if cust2.Find('-') then begin
                   end;
                 NCount:=NCount+1;
                 TCount:=TCount+1;
                 if Prog.Get("ACA-Course Registration".Programme) then
                 ProgName:=Prog.Description
                 else
                 ProgName:='';

                 if Cust.Get("ACA-Course Registration"."Student No.") then
                 CustName:=Cust.Name
                 else
                 CustName:='';

                 StudHostel.Reset;
                 StudHostel.SetRange(StudHostel.Student,"ACA-Course Registration"."Student No.");
                 StudHostel.SetRange(StudHostel.Semester,"ACA-Course Registration".Semester);
                 StudHostel.SetFilter(StudHostel.Cleared,'%1',false);
                 if StudHostel.Find('-') then
                 RoomNo:=StudHostel."Space No";

                 if "ACA-Course Registration"."Settlement Type"='SSP' then
                 SSCount:=SSCount+1;
                 if "ACA-Course Registration"."Settlement Type"='JAB' then
                 JCount:=JCount+1;
                 if "ACA-Course Registration"."Settlement Type"='IB' then
                 IBCount:=IBCount+1;
                 if "ACA-Course Registration".Gender="ACA-Course Registration".Gender::" " then
                 MCount:=MCount+1;
                 if "ACA-Course Registration".Gender="ACA-Course Registration".Gender::Male then
                 FCount:=FCount+1;

                 if "ACA-Course Registration"."Registration Date"<>0D then
                 "ACA-Course Registration".Validate("ACA-Course Registration"."Registration Date");
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Programme);
                NCount:=0;
                if "ACA-Course Registration".GetFilter("ACA-Course Registration"."Semester Filter")<>'' then
                 "ACA-Course Registration".SetFilter("ACA-Course Registration".Semester,"ACA-Course Registration".GetFilter(
                 "ACA-Course Registration"."Semester Filter"));
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Prog: Record UnknownRecord61511;
        Cust: Record Customer;
        CustName: Code[100];
        ProgName: Code[100];
        NCount: Integer;
        TCount: Integer;
        JCount: Integer;
        SSCount: Integer;
        IBCount: Integer;
        MCount: Integer;
        FCount: Integer;
        StudHostel: Record "ACA-Students Hostel Rooms";
        RoomNo: Code[20];
        Enrollment_Details__All_StudentsCaptionLbl: label 'Enrollment Details- All Students';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Academic_Year_CaptionLbl: label 'Academic Year:';
        FacultyCaptionLbl: label 'Faculty';
        Student_NameCaptionLbl: label 'Student Name';
        YearCaptionLbl: label 'Year';
        SignCaptionLbl: label 'Sign';
        DateCaptionLbl: label 'Date';
        Total_Students_CaptionLbl: label 'Total Students:';
        Total_Male_CaptionLbl: label 'Total Male:';
        Total_Female_CaptionLbl: label 'Total Female:';
        Total_IB_CaptionLbl: label 'Total IB:';
        Total_SSP_CaptionLbl: label 'Total SSP:';
        Total_JAB_CaptionLbl: label 'Total JAB:';
        ValUnits: Boolean;
        cust2: Record Customer;
        faculty: Record "Dimension Value";
}

