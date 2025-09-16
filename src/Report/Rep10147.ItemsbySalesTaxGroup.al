#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10147 "Items by Sales Tax Group"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Items by Sales Tax Group.rdlc';
    Caption = 'Items by Sales Tax Group';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Tax Group";"Tax Group")
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(ReportForNavId_6966; 6966)
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
            column(Tax_Group__TABLECAPTION__________TaxGrpFilter;"Tax Group".TableCaption + ': ' + TaxGrpFilter)
            {
            }
            column(TaxGrpFilter;TaxGrpFilter)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(TABLECAPTION_________FIELDCAPTION_Code___________Code;TableCaption + ' ' + FieldCaption(Code) + ': ' + Code)
            {
            }
            column(Tax_Group_Description;Description)
            {
            }
            column(Tax_Group_Code;Code)
            {
            }
            column(Items_by_Sales_Tax_GroupCaption;Items_by_Sales_Tax_GroupCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption;Item.FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption;Item.FieldCaption(Description))
            {
            }
            column(Item__Vendor_No__Caption;Item.FieldCaption("Vendor No."))
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;Item.FieldCaption("Base Unit of Measure"))
            {
            }
            column(Item__Shelf_No__Caption;Item.FieldCaption("Shelf No."))
            {
            }
            column(Item__Inventory_Posting_Group_Caption;Item.FieldCaption("Inventory Posting Group"))
            {
            }
            column(Item_BlockedCaption;Item.FieldCaption(Blocked))
            {
            }
            column(Item_CommentCaption;Item.FieldCaption(Comment))
            {
            }
            dataitem(Item;Item)
            {
                CalcFields = Comment;
                DataItemLink = "Tax Group Code"=field(Code);
                RequestFilterFields = "No.","Shelf No.","Inventory Posting Group","Vendor No.";
                column(ReportForNavId_8129; 8129)
                {
                }
                column(Item__No__;"No.")
                {
                }
                column(Item_Description;Description)
                {
                }
                column(Item__Vendor_No__;"Vendor No.")
                {
                }
                column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
                {
                }
                column(Item__Shelf_No__;"Shelf No.")
                {
                }
                column(Item__Inventory_Posting_Group_;"Inventory Posting Group")
                {
                }
                column(Item_Blocked;Blocked)
                {
                }
                column(Item_Comment;Comment)
                {
                }
                column(Item_Tax_Group_Code;"Tax Group Code")
                {
                }
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
        TaxGrpFilter := "Tax Group".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ItemFilter: Text;
        TaxGrpFilter: Text;
        Items_by_Sales_Tax_GroupCaptionLbl: label 'Items by Sales Tax Group';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

