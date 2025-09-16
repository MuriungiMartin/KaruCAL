#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51570 "Pass List - Grouped 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pass List - Grouped 2.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("General Remark");
            RequestFilterFields = "General Remark";
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
            column(USERID;UserId)
            {
            }
            column(Course_Registration__General_Remark_;"General Remark")
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Pass_ListCaption;Pass_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
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

            trigger OnAfterGetRecord()
            begin

                RCount:=RCount+1;

                if Cust.Get("ACA-Course Registration"."Student No.") then
;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("General Remark");
                RCount:=0;
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
        Grading: Record UnknownRecord61569;
        StudUnits: Record UnknownRecord61549;
        FailScore: Decimal;
        PassedUnits: Integer;
        Remark: Text[150];
        RCount: Integer;
        Units: Record UnknownRecord61517;
        UDesc: Text[200];
        Pass_ListCaptionLbl: label 'Pass List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

