#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51416 "WF Student Password"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Student Password.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Posting Group"=const('STUDENT'));
            RequestFilterFields = "No.";
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
            column(Customer__No___Control1102760011;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer_City;City)
            {
            }
            column(Customer_Password;Password)
            {
            }
            column(CustomerCaption;CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No___Control1102760011Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer_CityCaption;FieldCaption(City))
            {
            }
            column(Customer_PasswordCaption;FieldCaption(Password))
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Password='' then  begin

                  firstpass:=CopyStr(Customer.Name, 3, 2);
                  "2ndpass":=Format(Random(9999),0);
                  Customer.Password:=firstpass+"2ndpass";
                  Modify;
                end
                else if ACTION1=Action1::Reset then begin
                  firstpass:=CopyStr(Customer.Name, 3, 2);
                  "2ndpass":=Format(Random(9999),0);
                  Customer.Password:=firstpass+"2ndpass";
                  Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        noseriesmgt: Codeunit NoSeriesManagement;
        firstpass: Text[30];
        "2ndpass": Text[30];
        ACTION1: Option " ",VIEW,Reset;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

