#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51626 "Multiple Programme Reg"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Multiple Programme Reg.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Type"=const(Student));
            column(ReportForNavId_6836; 6836)
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Multiple_Programme_RegistrationCaption;Multiple_Programme_RegistrationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Multiple:=false;

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.",Customer."No.");
                if CourseReg.Find('-') then begin
                ProgCode:=CourseReg.Programme;
                repeat
                if ProgCode<> CourseReg.Programme then
                Multiple:=true;
                until CourseReg.Next = 0;
                end;
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
        CourseReg: Record UnknownRecord61532;
        ProgCode: Code[20];
        Multiple: Boolean;
        Multiple_Programme_RegistrationCaptionLbl: label 'Multiple Programme Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

