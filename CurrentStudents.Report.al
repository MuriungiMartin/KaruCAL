#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51294 "Current Students"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Current Students.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Posting Group"=const('STUDENT'),Status=const(Current));
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
            column(Customer_Name;Name)
            {
            }
            column(Customer__Search_Name_;"Search Name")
            {
            }
            column(Customer__Name_2_;"Name 2")
            {
            }
            column(int;int)
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
            column(Customer__Search_Name_Caption;FieldCaption("Search Name"))
            {
            }
            column(Customer__Name_2_Caption;FieldCaption("Name 2"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                  CReg.Reset;
                  CReg.SetRange(CReg."Student No.",Customer."No.");
                  CReg.SetRange(CReg.Semester,Customer.GetFilter(Customer."Semester Filter"));
                if CReg.Find('-') then int := int + 1
                else CurrReport.Skip;
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
        int: Integer;
        CReg: Record UnknownRecord61532;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

