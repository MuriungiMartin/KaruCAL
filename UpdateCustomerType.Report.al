#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51529 "Update Customer Type"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Customer Type.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
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
            column(Customer__Customer_Posting_Group_;"Customer Posting Group")
            {
            }
            column(Customer__Customer_Type_;"Customer Type")
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
            column(Customer__Customer_Posting_Group_Caption;FieldCaption("Customer Posting Group"))
            {
            }
            column(Customer__Customer_Type_Caption;FieldCaption("Customer Type"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                  Customer.Reset;
                  Customer.SetRange("Customer Posting Group", 'STUDENT');
                  Customer.SetRange("No.",'P100/0887G/17');
                  Customer.SetFilter(Status,'=%1|%2',Customer.Status::Current,Customer.Status::Registration);
                  if Customer.FindFirst then begin
                  repeat
                    Customer.Password := Customer."ID No";
                    Customer."Changed Password" := true;
                    Customer.Modify;
                    until Customer.Next = 0;
                  end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
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
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

