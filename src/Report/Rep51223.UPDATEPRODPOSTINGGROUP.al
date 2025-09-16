#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51223 "UPDATE PROD. POSTING GROUP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/UPDATE PROD. POSTING GROUP.rdlc';

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("Gen. Prod. Posting Group");
            RequestFilterFields = "Gen. Prod. Posting Group";
            column(ReportForNavId_8129; 8129)
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
            column(Item__Gen__Prod__Posting_Group_;"Gen. Prod. Posting Group")
            {
            }
            column(Item__Inventory_Posting_Group_;"Inventory Posting Group")
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item__No__2_;"No. 2")
            {
            }
            column(Item__Gen__Prod__Posting_Group__Control1102755017;"Gen. Prod. Posting Group")
            {
            }
            column(Item__VAT_Prod__Posting_Group_;"VAT Prod. Posting Group")
            {
            }
            column(ItemCaption;ItemCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption;FieldCaption("No."))
            {
            }
            column(Item__No__2_Caption;FieldCaption("No. 2"))
            {
            }
            column(Item__Gen__Prod__Posting_Group__Control1102755017Caption;FieldCaption("Gen. Prod. Posting Group"))
            {
            }
            column(Item__VAT_Prod__Posting_Group_Caption;FieldCaption("VAT Prod. Posting Group"))
            {
            }
            column(Item__Inventory_Posting_Group_Caption;FieldCaption("Inventory Posting Group"))
            {
            }
            column(Item__Gen__Prod__Posting_Group_Caption;FieldCaption("Gen. Prod. Posting Group"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                // Item."VAT Prod. Posting Group":='STANDARD';
                Item."Inventory Posting Group":='HSEKEEPING';
                 Modify;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Gen. Prod. Posting Group");
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
        ItemCaptionLbl: label 'Item';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

