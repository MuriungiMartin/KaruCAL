#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5702 "Inventory - Inbound Transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory - Inbound Transfer.rdlc';
    Caption = 'Inventory - Inbound Transfer';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Transfer Line";"Transfer Line")
        {
            DataItemTableView = sorting("Transfer-to Code",Status,"Derived From Line No.","Item No.","Variant Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Receipt Date","In-Transit Code") where(Status=const(Released),"Derived From Line No."=const(0));
            RequestFilterFields = "Transfer-to Code","Item No.","Receipt Date";
            column(ReportForNavId_9370; 9370)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(Location_Name;Location.Name)
            {
            }
            column(TransfertoCode_TransLine;"Transfer-to Code")
            {
            }
            column(Item_Description;Item.Description)
            {
            }
            column(ItemNo_TransLine;"Item No.")
            {
            }
            column(ReceiptDate_TransLine;Format("Receipt Date"))
            {
            }
            column(InTransitCode_TransLine;"In-Transit Code")
            {
                IncludeCaption = true;
            }
            column(QtyinTransit_TransLine;"Qty. in Transit")
            {
                IncludeCaption = true;
            }
            column(DocNo_TransLine;"Document No.")
            {
                IncludeCaption = true;
            }
            column(TransromCode_TransLine;"Transfer-from Code")
            {
                IncludeCaption = true;
            }
            column(OutstandQty_TransLine;"Outstanding Quantity")
            {
                IncludeCaption = true;
            }
            column(ReceiptDate_TransLineCaption;ReceiptDate_TransLineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Inventory___Inbound_TransferCaption;Inventory___Inbound_TransferCaptionLbl)
            {
            }
            column(TransfertoCode_TransLineCaption;TransfertoCode_TransLineCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Item.Get("Item No.");
                Location.Get("Transfer-to Code");
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
        Item: Record Item;
        Location: Record Location;
        ReceiptDate_TransLineCaptionLbl: label 'Receipt Date';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Inventory___Inbound_TransferCaptionLbl: label 'Inventory - Inbound Transfer';
        TransfertoCode_TransLineCaptionLbl: label 'Transfer-to';
}

