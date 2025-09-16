#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10161 "Serial Number Status/Aging"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Serial Number StatusAging.rdlc';
    Caption = 'Serial Number Status/Aging';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = where("Item Tracking Code"=filter(<>''));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Inventory Posting Group","Vendor No.","Location Filter","Variant Filter";
            column(ReportForNavId_8129; 8129)
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
            column(STRSUBSTNO_Text000_WORKDATE_;StrSubstNo(Text000,WorkDate))
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(Item_Date_Filter;"Date Filter")
            {
            }
            column(Item_Location_Filter;"Location Filter")
            {
            }
            column(Item_Variant_Filter;"Variant Filter")
            {
            }
            column(Item_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Serial_Number_Status_AgingCaption;Serial_Number_Status_AgingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption;FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Item_Ledger_Entry__Location_Code_Caption;"Item Ledger Entry".FieldCaption("Location Code"))
            {
            }
            column(Item_Ledger_Entry__Serial_No__Caption;"Item Ledger Entry".FieldCaption("Serial No."))
            {
            }
            column(Item_Ledger_Entry__Posting_Date_Caption;"Item Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(DaysAgedCaption;DaysAgedCaptionLbl)
            {
            }
            column(UnitCostCaption;UnitCostCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Lot_No__Caption;"Item Ledger Entry".FieldCaption("Lot No."))
            {
            }
            column(Item_Ledger_Entry__Remaining_Quantity_Caption;"Item Ledger Entry".FieldCaption("Remaining Quantity"))
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No."),"Posting Date"=field("Date Filter"),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date","Expiration Date","Lot No.","Serial No.") where(Open=const(true));
                column(ReportForNavId_7209; 7209)
                {
                }
                column(Item_Ledger_Entry__Location_Code_;"Location Code")
                {
                }
                column(Item_Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(DaysAged;DaysAged)
                {
                }
                column(UnitCost;UnitCost)
                {
                    DecimalPlaces = 2:5;
                }
                column(Item_Ledger_Entry__Remaining_Quantity_;"Remaining Quantity")
                {
                }
                column(Item_Ledger_Entry__Lot_No__;"Lot No.")
                {
                }
                column(Item_Ledger_Entry__Serial_No__;"Serial No.")
                {
                }
                column(AverageAge;AverageAge)
                {
                }
                column(Item__No___Control23;Item."No.")
                {
                }
                column(Item_Ledger_Entry__Remaining_Quantity__Control24;"Remaining Quantity")
                {
                    DecimalPlaces = 0:5;
                }
                column(TotalDaysAged;TotalDaysAged)
                {
                }
                column(Item_Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Item_Ledger_Entry_Item_No_;"Item No.")
                {
                }
                column(Item_Ledger_Entry_Variant_Code;"Variant Code")
                {
                }
                column(Item_Ledger_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                {
                }
                column(Item_Ledger_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DaysAged := WorkDate - "Posting Date";
                    TotalDaysAged := TotalDaysAged + DaysAged;
                    CalcFields("Cost Amount (Actual)");
                    UnitCost := "Cost Amount (Actual)" / Quantity;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Remaining Quantity");
                    TotalDaysAged := 0;
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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        ItemFilter := Item.GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ItemFilter: Text;
        DaysAged: Integer;
        TotalDaysAged: Integer;
        AverageAge: Decimal;
        Text000: label '(As of %1)';
        UnitCost: Decimal;
        Serial_Number_Status_AgingCaptionLbl: label 'Serial Number Status/Aging';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DaysAgedCaptionLbl: label 'Days Aged';
        UnitCostCaptionLbl: label 'Unit Cost';
}

