#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51320 "VAT On Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT On Report.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = sorting("Entry No.") where("G/L Account No."=const('200011'));
            RequestFilterFields = "Document No.","Posting Date";
            column(ReportForNavId_7069; 7069)
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
            column(G_L_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(G_L_Entry__Document_No__;"Document No.")
            {
            }
            column(G_L_Entry_Description;Description)
            {
            }
            column(G_L_Entry_Amount;Amount)
            {
            }
            column(VendDesc;VendDesc)
            {
            }
            column(G_L_Entry_Amount_Control1102760010;Amount)
            {
            }
            column(VAT_ReportCaption;VAT_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(G_L_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(G_L_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(G_L_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(SupplierCaption;SupplierCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  if Purch.Get("G/L Entry"."Document No.") then begin
                     VendDesc:=Purch."Pay-to Name"
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
        Supplier: Record Vendor;
        VendDesc: Text[30];
        Purch: Record "Purch. Inv. Header";
        VAT_ReportCaptionLbl: label 'VAT Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        SupplierCaptionLbl: label 'Supplier';
        TotalCaptionLbl: label 'Total';
}

