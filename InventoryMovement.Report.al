#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7321 "Inventory Movement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory Movement.rdlc';
    Caption = 'Inventory Movement';

    dataset
    {
        dataitem("Item Journal Batch";"Item Journal Batch")
        {
            DataItemTableView = sorting("Journal Template Name",Name);
            RequestFilterFields = "Journal Template Name",Name;
            column(ReportForNavId_8780; 8780)
            {
            }
            column(JournalTempName_ItemJournalBatch;"Journal Template Name")
            {
            }
            column(Name_ItemJournalBatch;Name)
            {
            }
            column(InventoryMovementCaption;InventoryMovementCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(JournalTempNameFieldCaption;"Item Journal Line".FieldCaption("Journal Template Name"))
            {
            }
            column(JournalBatchNameFieldCaption;"Item Journal Line".FieldCaption("Journal Batch Name"))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(Time;Time)
            {
            }
            dataitem("Item Journal Line";"Item Journal Line")
            {
                DataItemLink = "Journal Template Name"=field("Journal Template Name"),"Journal Batch Name"=field(Name);
                RequestFilterFields = "Journal Template Name","Journal Batch Name","Location Code","Bin Code","Item No.","Variant Code";
                column(ReportForNavId_8280; 8280)
                {
                }
                column(JournalTempName_ItemJournalLine;"Journal Template Name")
                {
                }
                column(JournalBatchName_ItemJournalLine;"Journal Batch Name")
                {
                }
                column(ActivityType;ActivityType)
                {
                    OptionCaption = ' ,Put-away,Pick,Movement';
                }
                column(ItemJnlLineActTypeShowOutput;ActivityType <> Activitytype::" ")
                {
                }
                column(ItemJournalLineTableCaption;TableCaption + ': ' + ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineFilter;ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineHeader1ShowOutput;ItemJnlTemplate.Type in [ItemJnlTemplate.Type::Item,ItemJnlTemplate.Type::Consumption,ItemJnlTemplate.Type::Output,ItemJnlTemplate.Type::"Prod. Order"])
                {
                }
                column(ItemJnlLineHeader2ShowOutput;ItemJnlTemplate.Type = ItemJnlTemplate.Type::Transfer)
                {
                }
                column(UOM_ItemJournalLine;"Unit of Measure Code")
                {
                }
                column(Qty_ItemJournalLine;Quantity)
                {
                }
                column(BinCode_ItemJournalLine;"Bin Code")
                {
                }
                column(LocationCode_ItemJournalLine;"Location Code")
                {
                }
                column(VariantCode_ItemJournalLine;"Variant Code")
                {
                }
                column(Description_ItemJournalLine;Description)
                {
                }
                column(ItemNo_ItemJournalLine;"Item No.")
                {
                }
                column(PostingDate_ItemJournalLine;Format("Posting Date"))
                {
                }
                column(EntryType_ItemJournalLine;"Entry Type")
                {
                }
                column(QuantityBase_ItemJournalLine;"Quantity (Base)")
                {
                }
                column(QuantityFormat;Quantity)
                {
                }
                column(NewBinCode_ItemJournalLine;"New Bin Code")
                {
                }
                column(NewLocationCode_ItemJournalLine;"New Location Code")
                {
                }
                column(QuantityBaseFormat;"Quantity (Base)")
                {
                }
                column(ActivityTypeCaption;ActivityTypeCaptionLbl)
                {
                }
                column(UOMFieldCaption;FieldCaption("Unit of Measure Code"))
                {
                }
                column(QtyFieldCaption;FieldCaption(Quantity))
                {
                }
                column(BinCodeFieldCaption;FieldCaption("Bin Code"))
                {
                }
                column(LocationCodeFieldCaption;FieldCaption("Location Code"))
                {
                }
                column(VariantCodeFieldCaption;FieldCaption("Variant Code"))
                {
                }
                column(DescriptionFieldCaption;FieldCaption(Description))
                {
                }
                column(ItemNoFieldCaption;FieldCaption("Item No."))
                {
                }
                column(PostingDateCaption;PostingDateCaptionLbl)
                {
                }
                column(EntryTypeFieldCaption;FieldCaption("Entry Type"))
                {
                }
                column(QuantityBaseFieldCaption;FieldCaption("Quantity (Base)"))
                {
                }
                column(NewBinCodeFieldCaption;FieldCaption("New Bin Code"))
                {
                }
                column(NewLocationCodeFieldCaption;FieldCaption("New Location Code"))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Entry Type" in ["entry type"::"Positive Adjmt.","entry type"::Purchase,"entry type"::Output]) and
                       (Quantity > 0) and
                       (ActivityType in [Activitytype::Pick,Activitytype::Movement])
                    then
                      CurrReport.Skip;

                    if ("Entry Type" in ["entry type"::"Negative Adjmt.","entry type"::Sale,"entry type"::Consumption]) and
                       (Quantity < 0) and
                       (ActivityType in [Activitytype::Pick,Activitytype::Movement])
                    then
                      CurrReport.Skip;

                    if ("Entry Type" in ["entry type"::"Positive Adjmt.","entry type"::Purchase,"entry type"::Output]) and
                       (Quantity < 0) and
                       (ActivityType in [Activitytype::"Put-away",Activitytype::Movement])
                    then
                      CurrReport.Skip;

                    if ("Entry Type" in ["entry type"::"Negative Adjmt.","entry type"::Sale,"entry type"::Consumption]) and
                       (Quantity > 0) and
                       (ActivityType in [Activitytype::"Put-away",Activitytype::Movement])
                    then
                      CurrReport.Skip;

                    if ("Entry Type" <> "entry type"::Transfer) and
                       (ActivityType = Activitytype::Movement)
                    then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    ItemJnlTemplate.Get("Item Journal Batch"."Journal Template Name");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.PageNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ActivityType;ActivityType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Activity Type';
                        OptionCaption = ' ,Put-away,Pick,Movement';
                    }
                }
            }
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
        ItemJnlLineFilter := "Item Journal Line".GetFilters;
    end;

    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLineFilter: Text;
        ActivityType: Option " ","Put-away",Pick,Movement;
        InventoryMovementCaptionLbl: label 'Inventory Movement';
        PageCaptionLbl: label 'Page';
        ActivityTypeCaptionLbl: label 'Activity Type';
        PostingDateCaptionLbl: label 'Posting Date';


    procedure InitializeRequest(NewActivityType: Option)
    begin
        ActivityType := NewActivityType;
    end;
}

