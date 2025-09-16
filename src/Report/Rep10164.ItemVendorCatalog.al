#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10164 "Item/Vendor Catalog"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ItemVendor Catalog.rdlc';
    Caption = 'Item/Vendor Catalog';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Item Vendor";"Item Vendor")
        {
            RequestFilterFields = "Item No.","Vendor No.";
            column(ReportForNavId_5437; 5437)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(Item_Vendor__TABLECAPTION__________ItemVendorFilter;"Item Vendor".TableCaption + ': ' + ItemVendorFilter)
            {
            }
            column(ItemVendorFilter;ItemVendorFilter)
            {
            }
            column(SortingOrder2;SortingOrder2)
            {
            }
            column(SortingOrder;SortingOrder)
            {
            }
            column(Item_Vendor__Vendor_No__;"Vendor No.")
            {
            }
            column(Vendor_Name;Vendor.Name)
            {
            }
            column(Vendor__Phone_No__;Vendor."Phone No.")
            {
            }
            column(Vendor_Contact;Vendor.Contact)
            {
            }
            column(Item_Vendor__Item_No__;"Item No.")
            {
            }
            column(Item_Description;Item.Description)
            {
            }
            column(Item_Vendor__Item_No___Control11;"Item No.")
            {
            }
            column(Item_Description_Control13;Item.Description)
            {
            }
            column(Item_Vendor__Lead_Time_Calculation_;"Lead Time Calculation")
            {
            }
            column(Item_Vendor__Vendor_Item_No__;"Vendor Item No.")
            {
            }
            column(PurchPrice__Starting_Date_;PurchPrice."Starting Date")
            {
            }
            column(PurchPrice__Direct_Unit_Cost_;PurchPrice."Direct Unit Cost")
            {
            }
            column(Item_Vendor__Vendor_No___Control23;"Vendor No.")
            {
            }
            column(Vendor_Name_Control25;Vendor.Name)
            {
            }
            column(Vendor__Phone_No___Control27;Vendor."Phone No.")
            {
            }
            column(Item_Vendor__Lead_Time_Calculation__Control31;"Lead Time Calculation")
            {
            }
            column(Item_Vendor__Vendor_Item_No___Control35;"Vendor Item No.")
            {
            }
            column(PurchPrice__Starting_Date__Control1020004;PurchPrice."Starting Date")
            {
            }
            column(PurchPrice__Direct_Unit_Cost__Control1020006;PurchPrice."Direct Unit Cost")
            {
            }
            column(Item_Vendor_Variant_Code;"Variant Code")
            {
            }
            column(Item_Vendor_CatalogCaption;Item_Vendor_CatalogCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item_Vendor__Item_No___Control11Caption;FieldCaption("Item No."))
            {
            }
            column(Item_Description_Control13Caption;Item_Description_Control13CaptionLbl)
            {
            }
            column(Item_Vendor__Lead_Time_Calculation_Caption;FieldCaption("Lead Time Calculation"))
            {
            }
            column(Item_Vendor__Vendor_Item_No__Caption;FieldCaption("Vendor Item No."))
            {
            }
            column(PurchPrice__Starting_Date_Caption;PurchPrice__Starting_Date_CaptionLbl)
            {
            }
            column(PurchPrice__Direct_Unit_Cost_Caption;PurchPrice__Direct_Unit_Cost_CaptionLbl)
            {
            }
            column(Item_Vendor__Vendor_No___Control23Caption;FieldCaption("Vendor No."))
            {
            }
            column(Vendor_Name_Control25Caption;Vendor_Name_Control25CaptionLbl)
            {
            }
            column(Vendor__Phone_No___Control27Caption;Vendor__Phone_No___Control27CaptionLbl)
            {
            }
            column(Item_Vendor__Lead_Time_Calculation__Control31Caption;FieldCaption("Lead Time Calculation"))
            {
            }
            column(Item_Vendor__Vendor_Item_No___Control35Caption;FieldCaption("Vendor Item No."))
            {
            }
            column(PurchPrice__Starting_Date__Control1020004Caption;PurchPrice__Starting_Date__Control1020004CaptionLbl)
            {
            }
            column(PurchPrice__Direct_Unit_Cost__Control1020006Caption;PurchPrice__Direct_Unit_Cost__Control1020006CaptionLbl)
            {
            }
            column(Vendor__Phone_No__Caption;Vendor__Phone_No__CaptionLbl)
            {
            }
            column(Vendor_ContactCaption;Vendor_ContactCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PurchPrice.Init;
                case SortOrder of
                  Sortorder::"By Vendor":
                    if not Item.Get("Item No.") then begin
                      Item.Init;
                      Item.Description := Text003;
                    end;
                  Sortorder::"By Item":
                    if not Vendor.Get("Vendor No.") then begin
                      Vendor.Init;
                      Vendor.Name := Text004;
                    end;
                end;

                if Vendor."No." <> "Vendor No." then
                  if not Vendor.Get("Vendor No.") then begin
                    Vendor.Init;
                    Vendor.Name := Text004;
                  end;
                if Item."No." <> "Item No." then
                  if not Item.Get("Item No.") then begin
                    Item.Init;
                    Item.Description := Text003;
                  end;

                PurchPrice.SetRange("Item No.","Item No.");
                PurchPrice.SetRange("Vendor No.","Vendor No.");
                PurchPrice.SetFilter("Starting Date",'%1..%2',0D,WorkDate);
                if PurchPrice.FindLast then;
            end;

            trigger OnPreDataItem()
            begin
                SortingString := "Item Vendor".CurrentKey;
                if CopyStr(SortingString,1,StrLen("Item Vendor".FieldCaption("Vendor No.")))
                   = "Item Vendor".FieldCaption("Vendor No.")
                then begin
                  if CopyStr(SortingString,StrLen("Item Vendor".FieldCaption("Vendor No.")) + 1,
                       StrLen("Item Vendor".FieldCaption("Item No.")))
                     = "Item Vendor".FieldCaption("Item No.")
                  then
                    SortingOrder2 := 1
                  else
                    SortingOrder2 := 3
                end else
                  SortingOrder2 := 2;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        SortOrder := WhichOrder;
        case SortOrder of
          Sortorder::"By Vendor":
            SubTitle := Text001;
          Sortorder::"By Item":
            SubTitle := Text002;
        end;
        ItemVendorFilter := "Item Vendor".GetFilters;

        case SortOrder of
          Sortorder::"By Vendor":
            SortingOrder := 1;
          Sortorder::"By Item":
            SortingOrder := 0;
        end;
    end;

    var
        Vendor: Record Vendor;
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        PurchPrice: Record "Purchase Price";
        SortOrder: Option "By Vendor","By Item";
        SubTitle: Text[132];
        ItemVendorFilter: Text;
        Text000: label 'You must select a sort order for %1 which starts with either %2 or %3.';
        Text001: label 'Items for each Vendor';
        Text002: label 'Vendors for each Item';
        Text003: label '<invalid item>';
        Text004: label '<invalid vendor>';
        SortingOrder: Integer;
        SortingString: Text[300];
        SortingOrder2: Integer;
        Item_Vendor_CatalogCaptionLbl: label 'Item/Vendor Catalog';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Item_Description_Control13CaptionLbl: label 'Item Description';
        PurchPrice__Starting_Date_CaptionLbl: label 'Starting Date';
        PurchPrice__Direct_Unit_Cost_CaptionLbl: label 'Direct Unit Cost';
        Vendor_Name_Control25CaptionLbl: label 'Vendor Name';
        Vendor__Phone_No___Control27CaptionLbl: label 'Phone No.';
        PurchPrice__Starting_Date__Control1020004CaptionLbl: label 'Starting Date';
        PurchPrice__Direct_Unit_Cost__Control1020006CaptionLbl: label 'Direct Unit Cost';
        Vendor__Phone_No__CaptionLbl: label 'Phone No.';
        Vendor_ContactCaptionLbl: label 'Contact';


    procedure WhichOrder() "Order": Integer
    var
        KeyString: Text[250];
    begin
        KeyString := "Item Vendor".CurrentKey;
        if CopyStr(KeyString,1,StrLen("Item Vendor".FieldCaption("Item No."))) = "Item Vendor".FieldCaption("Item No.") then
          exit(1);
        if CopyStr(KeyString,1,StrLen("Item Vendor".FieldCaption("Vendor No."))) = "Item Vendor".FieldCaption("Vendor No.") then
          exit(0);

        Error(Text000,
          "Item Vendor".TableCaption,
          "Item Vendor".FieldCaption("Item No."),
          "Item Vendor".FieldCaption("Vendor No."));
    end;
}

