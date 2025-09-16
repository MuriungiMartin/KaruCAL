#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51291 "HTL Items Level"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HTL Items Level.rdlc';

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.") order(ascending);
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.","Inventory Posting Group";
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
            column(Loc;Loc)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(inv;inv)
            {
            }
            column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(ITEMS_LEVELSCaption;ITEMS_LEVELSCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(LocationCaption;LocationCaptionLbl)
            {
            }
            column(Item__No__Caption;FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(InventoryCaption;InventoryCaptionLbl)
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;FieldCaption("Base Unit of Measure"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                   if Loc=0 then begin
                     Error('You Must Select The Location')
                   end;

                   inv:=0;
                   ItmLedger2.Reset;
                   ItmLedger2.SetRange(ItmLedger2."Location Code",Format(Loc));
                   if ItmLedger2.Find('-') then
                    begin
                     ItmLedger.Reset;
                     ItmLedger.SetRange(ItmLedger."Item No.",Item."No.");
                     ItmLedger.SetRange(ItmLedger."Location Code",Format(Loc));
                     if ItmLedger.Find('-') then
                      begin
                       repeat
                       inv:=inv+ItmLedger.Quantity
                       until ItmLedger.Next=0;
                      end;
                   end
                   else begin
                     CurrReport.Skip
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
        Loc: Option ," ",HOTEL,"HTL EXEC","HTL POOL","HTL RESTAU",HTLTERRACE;
        inv: Decimal;
        ItmLedger: Record "Item Ledger Entry";
        ItmLedger2: Record "Item Ledger Entry";
        ITEMS_LEVELSCaptionLbl: label 'ITEMS LEVELS';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        LocationCaptionLbl: label 'Location';
        InventoryCaptionLbl: label 'Inventory';
}

