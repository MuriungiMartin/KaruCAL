#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51544 "Generate Late Pay Charge"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate Late Pay Charge.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Type"=const(Student),"Balance (LCY)"=filter(>1.000));
            RequestFilterFields = "No.",Adults,"Semester Filter","Date Filter";
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
            column(CustomerCaption;CustomerCaptionLbl)
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
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No."),Programme=field(Adults),Semester=field("Semester Filter");
                column(ReportForNavId_2901; 2901)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    StudentCharges.Init;
                    StudentCharges.Programme:=Programme;
                    StudentCharges.Stage:=Stage;
                    StudentCharges.Semester:=Semester;
                    StudentCharges."Student No.":="Student No.";
                    StudentCharges."Reg. Transacton ID":="Reg. Transacton ID";
                    StudentCharges."Transaction Type":=StudentCharges."transaction type"::"Stage Fees";
                    StudentCharges.Date:=Today;
                    StudentCharges.Code:=Charge.Code;
                    StudentCharges.Description:=Charge.Description;
                    StudentCharges.Amount:=Charge.Amount;
                    StudentCharges."Recovery Priority":=27;
                    StudentCharges.Currency:=Charge.Currency;
                    StudentCharges.Charge:=true;
                    StudentCharges."Transacton ID":='';
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges.Insert;
                end;

                trigger OnPreDataItem()
                begin
                    if Charge.Get('INST') = false then
                    Error('Installment charge not set-up i.e "INST"');
                end;
            }
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
        Charge: Record UnknownRecord61515;
        StudentCharges: Record UnknownRecord61535;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

