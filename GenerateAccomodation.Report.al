#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51586 "Generate Accomodation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate Accomodation.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Balance (LCY)"=filter(-2.900|-2.100|-3.400));
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
            column(Customer__Balance__LCY__;"Balance (LCY)")
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
            column(Customer__Balance__LCY__Caption;FieldCaption("Balance (LCY)"))
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No.");
                DataItemTableView = where("System Created"=const(Yes));
                column(ReportForNavId_2901; 2901)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Evaluate(PDate,'01/09/08');
                    StudentCharges.Init;
                    StudentCharges.Programme:=Programme;
                    StudentCharges.Stage:=Stage;
                    StudentCharges.Semester:=Semester;
                    StudentCharges."Student No.":="Student No.";
                    StudentCharges."Reg. Transacton ID":="Reg. Transacton ID";
                    StudentCharges."Transaction Type":=StudentCharges."transaction type"::"Stage Fees";
                    StudentCharges.Date:=PDate;
                    StudentCharges.Description:='Accomodation Fee';
                    if Customer."Balance (LCY)" = -3400 then begin
                    StudentCharges.Code:='ACC1';
                    StudentCharges.Amount:=3400;
                    end else if Customer."Balance (LCY)" = -2100 then begin
                    StudentCharges.Code:='ACC3';
                    StudentCharges.Amount:=2100;
                    end else begin
                    StudentCharges.Code:='ACC2';
                    StudentCharges.Amount:=2900;
                    end;

                    StudentCharges."Recovered First":=false;
                    StudentCharges."Recovery Priority":=12;
                    StudentCharges."System Created":=true;
                    StudentCharges.Charge:=true;
                    StudentCharges."Transacton ID":='';
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges.Insert;
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
        StudentCharges: Record UnknownRecord61535;
        PDate: Date;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

