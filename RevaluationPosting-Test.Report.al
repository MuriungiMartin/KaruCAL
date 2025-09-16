#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5812 "Revaluation Posting - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Revaluation Posting - Test.rdlc';
    Caption = 'Revaluation Posting - Test';

    dataset
    {
        dataitem("Item Journal Batch";"Item Journal Batch")
        {
            DataItemTableView = sorting("Journal Template Name",Name);
            RequestFilterFields = "Journal Template Name",Name;
            column(ReportForNavId_8780; 8780)
            {
            }
            column(Item_Journal_Batch_Journal_Template_Name;"Journal Template Name")
            {
            }
            column(Item_Journal_Batch_Name;Name)
            {
            }
            dataitem("Item Journal Line";"Item Journal Line")
            {
                DataItemLink = "Journal Template Name"=field("Journal Template Name"),"Journal Batch Name"=field(Name);
                DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.");
                RequestFilterFields = "Posting Date";
                column(ReportForNavId_8280; 8280)
                {
                }
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(Item_Journal_Line__Journal_Template_Name_;"Journal Template Name")
                {
                }
                column(Item_Journal_Line__Journal_Batch_Name_;"Journal Batch Name")
                {
                }
                column(Item_Journal_Line__TABLECAPTION__________ItemJnlLineFilter;TableCaption + ': ' + ItemJnlLineFilter)
                {
                }
                column(ItemJnlLineFilter;ItemJnlLineFilter)
                {
                }
                column(Item_Journal_Line__Posting_Date_;Format("Posting Date"))
                {
                }
                column(Item_Journal_Line__Item_No__;"Item No.")
                {
                }
                column(Item_Journal_Line_Description;Description)
                {
                }
                column(Item_Journal_Line_Quantity;Quantity)
                {
                }
                column(Item_Journal_Line_Amount;Amount)
                {
                }
                column(Item_Journal_Line__Unit_Cost__Calculated__;"Unit Cost (Calculated)")
                {
                }
                column(Item_Journal_Line__Unit_Cost__Revalued__;"Unit Cost (Revalued)")
                {
                }
                column(Item_Journal_Line__Inventory_Value__Calculated__;"Inventory Value (Calculated)")
                {
                }
                column(Item_Journal_Line__Inventory_Value__Revalued__;"Inventory Value (Revalued)")
                {
                }
                column(Item_Journal_Line_Amount_Control43;Amount)
                {
                }
                column(Item_Journal_Line_Line_No_;"Line No.")
                {
                }
                column(Revaluation_Posting___TestCaption;Revaluation_Posting___TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Item_Journal_Line__Journal_Template_Name_Caption;FieldCaption("Journal Template Name"))
                {
                }
                column(Item_Journal_Line__Journal_Batch_Name_Caption;FieldCaption("Journal Batch Name"))
                {
                }
                column(Item_Journal_Line__Posting_Date_Caption;Item_Journal_Line__Posting_Date_CaptionLbl)
                {
                }
                column(Item_Journal_Line__Item_No__Caption;FieldCaption("Item No."))
                {
                }
                column(Item_Journal_Line_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Item_Journal_Line_QuantityCaption;FieldCaption(Quantity))
                {
                }
                column(Item_Journal_Line_AmountCaption;FieldCaption(Amount))
                {
                }
                column(Item_Journal_Line__Unit_Cost__Calculated__Caption;FieldCaption("Unit Cost (Calculated)"))
                {
                }
                column(Item_Journal_Line__Unit_Cost__Revalued__Caption;FieldCaption("Unit Cost (Revalued)"))
                {
                }
                column(Item_Journal_Line__Inventory_Value__Calculated__Caption;FieldCaption("Inventory Value (Calculated)"))
                {
                }
                column(Item_Journal_Line__Inventory_Value__Revalued__Caption;FieldCaption("Inventory Value (Revalued)"))
                {
                }
                column(Item_Journal_Line_Amount_Control43Caption;Item_Journal_Line_Amount_Control43CaptionLbl)
                {
                }
                dataitem(DimensionLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_9775; 9775)
                    {
                    }
                    column(DimText;DimText)
                    {
                    }
                    column(Number;Number)
                    {
                    }
                    column(DimensionsCaption;DimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                          if not DimSetEntry.FindSet then
                            CurrReport.Break;
                        end else
                          if not Continue then
                            CurrReport.Break;

                        Clear(DimText);
                        Continue := false;
                        repeat
                          OldDimText := DimText;
                          if DimText = '' then
                            DimText := StrSubstNo('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
                          else
                            DimText :=
                              StrSubstNo(
                                '%1; %2 - %3',DimText,DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
                          if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                            DimText := OldDimText;
                            Continue := true;
                            exit;
                          end;
                        until DimSetEntry.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowDim then
                          CurrReport.Break;
                        DimSetEntry.SetRange("Dimension Set ID","Item Journal Line"."Dimension Set ID");
                    end;
                }
                dataitem(ErrorLoop;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_1162; 1162)
                    {
                    }
                    column(ErrorText_Number_;ErrorText[Number])
                    {
                    }
                    column(ErrorText_Number_Caption;ErrorText_Number_CaptionLbl)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        ErrorCounter := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number,1,ErrorCounter);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    InvtPeriodEndDate: Date;
                begin
                    if ("Item No." = '') and (Quantity = 0) then
                      exit;

                    if "Item No." = '' then
                      AddError(StrSubstNo(Text001,FieldCaption("Item No.")))
                    else
                      if not Item.Get("Item No.") then
                        AddError(
                          StrSubstNo(
                            Text002,
                            Item.TableCaption,"Item No."))
                      else begin
                        if Item.Blocked then
                          AddError(
                            StrSubstNo(
                              Text003,
                              Item.FieldCaption(Blocked),false,Item.TableCaption,"Item No."));
                      end;

                    if "Posting Date" = 0D then
                      AddError(StrSubstNo(Text001,FieldCaption("Posting Date")))
                    else begin
                      if "Posting Date" <> NormalDate("Posting Date") then
                        AddError(StrSubstNo(Text004,FieldCaption("Posting Date")));

                      if "Item Journal Batch"."No. Series" <> '' then
                        if NoSeries."Date Order" and ("Posting Date" < LastPostingDate) then
                          AddError(Text005);
                      LastPostingDate := "Posting Date";

                      if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                        if UserId <> '' then
                          if UserSetup.Get(UserId) then begin
                            AllowPostingFrom := UserSetup."Allow Posting From";
                            AllowPostingTo := UserSetup."Allow Posting To";
                          end;
                        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                          AllowPostingFrom := GLSetup."Allow Posting From";
                          AllowPostingTo := GLSetup."Allow Posting To";
                        end;
                        if AllowPostingTo = 0D then
                          AllowPostingTo := Dmy2date(31,12,9999);
                      end;

                      if ("Posting Date" < AllowPostingFrom) or ("Posting Date" > AllowPostingTo) then
                        AddError(
                          StrSubstNo(
                            Text006,Format("Posting Date")))
                      else begin
                        InvtPeriodEndDate := "Posting Date";
                        if not InvtPeriod.IsValidDate(InvtPeriodEndDate) then
                          AddError(
                            StrSubstNo(
                              Text006,Format("Posting Date")))
                      end;
                    end;

                    if "Document Date" <> 0D then
                      if "Document Date" <> NormalDate("Document Date") then
                        AddError(StrSubstNo(Text004,FieldCaption("Document Date")));

                    if "Gen. Prod. Posting Group" = '' then
                      AddError(StrSubstNo(Text001,FieldCaption("Gen. Prod. Posting Group")))
                    else
                      if not GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group") then
                        AddError(
                          StrSubstNo(
                            Text007,GenPostingSetup.TableCaption,
                            "Gen. Bus. Posting Group","Gen. Prod. Posting Group"));

                    if InvtSetup."Location Mandatory" then begin
                      if "Location Code" = '' then
                        AddError(StrSubstNo(Text001,FieldCaption("Location Code")));
                    end;

                    if "Item Journal Batch"."No. Series" <> '' then begin
                      if LastDocNo <> '' then
                        if ("Document No." <> LastDocNo) and ("Document No." <> IncStr(LastDocNo)) then
                          AddError(Text008);
                      LastDocNo := "Document No.";
                    end;

                    if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                      AddError(DimMgt.GetDimCombErr);

                    TableID[1] := Database::Item;
                    No[1] := "Item No.";
                    TableID[2] := Database::"Salesperson/Purchaser";
                    No[2] := "Salespers./Purch. Code";
                    if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
                      AddError(DimMgt.GetDimValuePostingErr);
                end;

                trigger OnPreDataItem()
                begin
                    if ItemJnlTemplate.Recurring then
                      AddError(StrSubstNo(Text000));

                    CurrReport.CreateTotals(
                      Amount,"Unit Cost (Calculated)","Unit Cost (Revalued)","Inventory Value (Calculated)",
                      "Inventory Value (Revalued)");
                    if "Item Journal Batch"."No. Series" <> '' then
                      NoSeries.Get("Item Journal Batch"."No. Series");
                    LastPostingDate := 0D;
                    LastDocNo := '';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ItemJnlTemplate.Get("Journal Template Name");
                if ItemJnlTemplate.Type <> ItemJnlTemplate.Type::Revaluation then
                  CurrReport.Skip;

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
                    field(ShowDim;ShowDim)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Dimensions';
                        ToolTip = 'Specifies if you want if you want the report to show dimensions.';
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
        GLSetup.Get;
        InvtSetup.Get;
    end;

    var
        Text000: label 'You cannot use a recurring journal for revaluations.';
        Text001: label '%1 must be specified.';
        Text002: label '%1 %2 does not exist.';
        Text003: label '%1 must be %2 for %3 %4.';
        Text004: label '%1 must not be a closing date.';
        Text005: label 'The lines are not listed according to posting date because they were not entered in that order.';
        Text006: label '%1 is not within your allowed range of posting dates.';
        Text007: label '%1 %2 %3 does not exist.';
        Text008: label 'There is a gap in the number series.';
        InvtSetup: Record "Inventory Setup";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Item: Record Item;
        ItemJnlTemplate: Record "Item Journal Template";
        GenPostingSetup: Record "General Posting Setup";
        NoSeries: Record "No. Series";
        DimSetEntry: Record "Dimension Set Entry";
        InvtPeriod: Record "Inventory Period";
        DimMgt: Codeunit DimensionManagement;
        ItemJnlLineFilter: Text;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        ErrorCounter: Integer;
        ErrorText: array [30] of Text[250];
        LastPostingDate: Date;
        LastDocNo: Code[20];
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowDim: Boolean;
        Continue: Boolean;
        Revaluation_Posting___TestCaptionLbl: label 'Revaluation Posting - Test';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Item_Journal_Line__Posting_Date_CaptionLbl: label 'Posting Date';
        Item_Journal_Line_Amount_Control43CaptionLbl: label 'Total';
        DimensionsCaptionLbl: label 'Dimensions';
        ErrorText_Number_CaptionLbl: label 'Warning!';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;


    procedure InitializeRequest(NewShowDim: Boolean)
    begin
        ShowDim := NewShowDim;
    end;
}

