#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51507 "KCA Insert Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Insert Charges.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","No. Of Receipts","No Of Charges";
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
            column(Customer__No__Of_Receipts_;"No. Of Receipts")
            {
            }
            column(Customer__No_Of_Charges_;"No Of Charges")
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
            column(Customer__No__Of_Receipts_Caption;FieldCaption("No. Of Receipts"))
            {
            }
            column(Customer__No_Of_Charges_Caption;FieldCaption("No Of Charges"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Customer.CalcFields(Customer."No. Of Receipts",Customer."No Of Charges");
                if Customer."No Of Charges" = 0 then begin
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.",Customer."No.");
                if CourseReg.Find('-') then begin
                CourseReg.Validate(CourseReg."Settlement Type");
                CourseReg.Modify;
                end;
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
        StudCharges: Record UnknownRecord61535;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

