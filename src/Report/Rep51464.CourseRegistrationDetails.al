#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51464 "Course Registration Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Course Registration Details.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = sorting(Unit);
            RequestFilterFields = Programme,Stage,Semester,"Unit Filter";
            column(ReportForNavId_2992; 2992)
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
            column(USERID;UserId)
            {
            }
            column(Student_Units_Unit;Unit)
            {
            }
            column(UnitSubj_Desription;UnitSubj.Desription)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(sCount;sCount)
            {
            }
            column(Student_UnitsCaption;Student_UnitsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_Units_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Student_Units_StageCaption;FieldCaption(Stage))
            {
            }
            column(Student_Units_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Student_NameCaption;Student_NameCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Student_Units_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 if Cust.Get("ACA-Student Units"."Student No.") then
                 CustName:=Cust.Name;

                 sCount:=sCount+1;

                 UnitSubj.Reset;
                 UnitSubj.SetRange(UnitSubj.Code,"ACA-Student Units".Unit);
                 if UnitSubj.Find('-') then
                 UnitDesc:=UnitSubj.Desription;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Unit);
                "ACA-Student Units".SetFilter("ACA-Student Units".Unit,"ACA-Student Units".GetFilter("ACA-Student Units"."Unit Filter"));
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        Cust: Record Customer;
        CustName: Text[100];
        UnitSubj: Record UnknownRecord61517;
        UnitDesc: Text[100];
        sCount: Integer;
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_NameCaptionLbl: label 'Student Name';
        EmptyStringCaptionLbl: label '#';
}

