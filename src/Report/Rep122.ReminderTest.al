#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 122 "Reminder - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reminder - Test.rdlc';
    Caption = 'Reminder - Test';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Reminder Header";"Reminder Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder';
            column(ReportForNavId_4775; 4775)
            {
            }
            column(Reminder_Header_No_;"No.")
            {
            }
            dataitem(PageCounter;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8098; 8098)
                {
                }
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(TextPage;TextPageLbl)
                {
                }
                column(STRSUBSTNO_Text008_ReminderHeaderFilter_;StrSubstNo(Text008,ReminderHeaderFilter))
                {
                }
                column(ReminderHeaderFilter;ReminderHeaderFilter)
                {
                }
                column(STRSUBSTNO___1__2___Reminder_Header___No___Cust_Name_;StrSubstNo('%1 %2',"Reminder Header"."No.",Cust.Name))
                {
                }
                column(CustAddr_8_;CustAddr[8])
                {
                }
                column(CustAddr_7_;CustAddr[7])
                {
                }
                column(CustAddr_6_;CustAddr[6])
                {
                }
                column(CustAddr_5_;CustAddr[5])
                {
                }
                column(CustAddr_4_;CustAddr[4])
                {
                }
                column(CustAddr_3_;CustAddr[3])
                {
                }
                column(CustAddr_2_;CustAddr[2])
                {
                }
                column(CustAddr_1_;CustAddr[1])
                {
                }
                column(Reminder_Header___Reminder_Terms_Code_;"Reminder Header"."Reminder Terms Code")
                {
                }
                column(Reminder_Header___Reminder_Level_;"Reminder Header"."Reminder Level")
                {
                }
                column(Reminder_Header___Document_Date_;Format("Reminder Header"."Document Date"))
                {
                }
                column(Reminder_Header___Posting_Date_;Format("Reminder Header"."Posting Date"))
                {
                }
                column(Reminder_Header___Post_Interest_;Format("Reminder Header"."Post Interest"))
                {
                }
                column(Reminder_Header___VAT_Registration_No__;"Reminder Header"."VAT Registration No.")
                {
                }
                column(Reminder_Header___Your_Reference_;"Reminder Header"."Your Reference")
                {
                }
                column(Reminder_Header___Post_Additional_Fee_;Format("Reminder Header"."Post Additional Fee"))
                {
                }
                column(Reminder_Header___Post_Additional_Fee_per_Line;Format("Reminder Header"."Post Add. Fee per Line"))
                {
                }
                column(Reminder_Header___Fin__Charge_Terms_Code_;"Reminder Header"."Fin. Charge Terms Code")
                {
                }
                column(Reminder_Header___Due_Date_;Format("Reminder Header"."Due Date"))
                {
                }
                column(Reminder_Header___Customer_No__;"Reminder Header"."Customer No.")
                {
                }
                column(ReferenceText;ReferenceText)
                {
                }
                column(VATNoText;VATNoText)
                {
                }
                column(FORMAT_Cust__Tax_Identification_Type__;Format(Cust."Tax Identification Type"))
                {
                }
                column(Reminder___TestCaption;Reminder___TestCaptionLbl)
                {
                }
                column(Reminder_Header___Reminder_Terms_Code_Caption;"Reminder Header".FieldCaption("Reminder Terms Code"))
                {
                }
                column(Reminder_Header___Reminder_Level_Caption;"Reminder Header".FieldCaption("Reminder Level"))
                {
                }
                column(Reminder_Header___Document_Date_Caption;Reminder_Header___Document_Date_CaptionLbl)
                {
                }
                column(Reminder_Header___Posting_Date_Caption;Reminder_Header___Posting_Date_CaptionLbl)
                {
                }
                column(Reminder_Header___Post_Interest_Caption;CaptionClassTranslate("Reminder Header".FieldCaption("Post Interest")))
                {
                }
                column(Reminder_Header___Post_Additional_Fee_Caption;CaptionClassTranslate("Reminder Header".FieldCaption("Post Additional Fee")))
                {
                }
                column(Reminder_Header___Post_Additional_Fee_per_Line_Caption;CaptionClassTranslate("Reminder Header".FieldCaption("Post Add. Fee per Line")))
                {
                }
                column(Reminder_Header___Fin__Charge_Terms_Code_Caption;"Reminder Header".FieldCaption("Fin. Charge Terms Code"))
                {
                }
                column(Reminder_Header___Due_Date_Caption;Reminder_Header___Due_Date_CaptionLbl)
                {
                }
                column(Reminder_Header___Customer_No__Caption;"Reminder Header".FieldCaption("Customer No."))
                {
                }
                column(Tax_Ident__TypeCaption;Tax_Ident__TypeCaptionLbl)
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
                    column(Header_DimensionsCaption;Header_DimensionsCaptionLbl)
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
                            exit;
                          end;
                        until DimSetEntry.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowDim then
                          CurrReport.Break;
                        DimSetEntry.SetRange("Dimension Set ID","Reminder Header"."Dimension Set ID");
                    end;
                }
                dataitem(HeaderErrorCounter;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_3850; 3850)
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
                dataitem("Reminder Line";"Reminder Line")
                {
                    DataItemLink = "Reminder No."=field("No.");
                    DataItemLinkReference = "Reminder Header";
                    DataItemTableView = sorting("Reminder No.","Line No.") where("Line Type"=filter(<>"Not Due"));
                    column(ReportForNavId_3496; 3496)
                    {
                    }
                    column(Reminder_Line_Description;Description)
                    {
                    }
                    column(Reminder_Line__Type;Type)
                    {
                    }
                    column(Reminder_Line__Document_No__;"Document No.")
                    {
                    }
                    column(Reminder_Line__Original_Amount_;"Original Amount")
                    {
                    }
                    column(Reminder_Line__Remaining_Amount_;"Remaining Amount")
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Reminder_Line__Document_Date_;Format("Document Date"))
                    {
                    }
                    column(Reminder_Line__Due_Date_;Format("Due Date"))
                    {
                    }
                    column(Reminder_Line__Document_Type_;"Document Type")
                    {
                    }
                    column(NNC_TotalLCYVATAmount;NNC_TotalLCYVATAmount)
                    {
                    }
                    column(NNC_VATAmount;NNC_VATAmount)
                    {
                    }
                    column(NNC_TotalLCY;NNC_TotalLCY)
                    {
                    }
                    column(NNC_Interest;NNC_Interest)
                    {
                    }
                    column(Reminder_Line__No__;"No.")
                    {
                    }
                    column(Text009;Text009Lbl)
                    {
                    }
                    column(Reminder_Header_Additional_Fee_AddFeeInclVAT_VATInterest_100__1;(ReminderInterestAmount + "VAT Amount" + "Reminder Header"."Additional Fee" - AddFeeInclVAT) / (VATInterest / 100 + 1))
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Remaining_Amount_VATInterest_100____Reminder_Header___Additional_Fee____AddFeeInclVAT;"Remaining Amount" + ReminderInterestAmount)
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(TotalText;TotalText)
                    {
                    }
                    column(Reminder_Header___Additional_Fee_;"VAT Amount")
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(TotalInclVATText;TotalInclVATText)
                    {
                    }
                    column(Remaining_Amount____ReminderInterestAmount____VAT_Amount_;"Remaining Amount" + ReminderInterestAmount + "VAT Amount")
                    {
                        AutoFormatExpression = GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Reminder_Line_Line_No_;"Line No.")
                    {
                    }
                    column(Reminder_Line__Original_Amount_Caption;FieldCaption("Original Amount"))
                    {
                    }
                    column(Reminder_Line__Remaining_Amount_Caption;FieldCaption("Remaining Amount"))
                    {
                    }
                    column(Reminder_Line__Due_Date_Caption;Reminder_Line__Due_Date_CaptionLbl)
                    {
                    }
                    column(Reminder_Line__Document_No__Caption;FieldCaption("Document No."))
                    {
                    }
                    column(Reminder_Line__Document_Date_Caption;Reminder_Line__Document_Date_CaptionLbl)
                    {
                    }
                    column(Reminder_Line__Document_Type_Caption;FieldCaption("Document Type"))
                    {
                    }
                    column(Text009Caption;Text009CaptionLbl)
                    {
                    }
                    column(ReminderInterestAmount_VATInterest_100__1_Caption;ReminderInterestAmount_VATInterest_100__1_CaptionLbl)
                    {
                    }
                    column(VAT_AmountCaption;VAT_AmountCaptionLbl)
                    {
                    }
                    column(Interest;Interest)
                    {
                    }
                    dataitem(LineErrorCounter;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2217; 2217)
                        {
                        }
                        column(ErrorText_Number__Control97;ErrorText[Number])
                        {
                        }
                        column(ErrorText_Number__Control97Caption;ErrorText_Number__Control97CaptionLbl)
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
                    begin
                        VATAmountLine.Init;
                        VATAmountLine."VAT Identifier" := "VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := "Tax Group Code";
                        VATAmountLine."VAT %" := "VAT %";
                        VATAmountLine."VAT Base" := Amount;
                        VATAmountLine."VAT Amount" := "VAT Amount";
                        VATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                        VATAmountLine.InsertLine;

                        case Type of
                          Type::"G/L Account":
                            "Remaining Amount" := Amount;
                          Type::"Line Fee":
                            "Remaining Amount" := Amount;
                          Type::"Customer Ledger Entry":
                            ReminderInterestAmount := Amount;
                        end;

                        TotalVATAmount += "VAT Amount";

                        NNC_RemAmtTotal += "Remaining Amount";
                        NNC_VatAmtTotal += "VAT Amount";
                        NNC_ReminderInterestAmt += ReminderInterestAmount;

                        NNC_Interest :=
                          (NNC_ReminderInterestAmt + NNC_VatAmtTotal + "Reminder Header"."Additional Fee" - AddFeeInclVAT +
                           "Reminder Header"."Add. Fee per Line" - AddFeePerLineInclVAT) /
                          (VATInterest / 100 + 1);

                        NNC_TotalLCY := NNC_RemAmtTotal + NNC_ReminderInterestAmt;

                        NNC_VATAmount := NNC_VatAmtTotal;

                        NNC_TotalLCYVATAmount := NNC_RemAmtTotal + NNC_VatAmtTotal + NNC_ReminderInterestAmt;
                    end;

                    trigger OnPreDataItem()
                    begin
                        TotalVATAmount := 0;

                        if Find('+') then
                          repeat
                            Continue := "No. of Reminders" = 0;
                          until ((Next(-1) = 0) or not Continue);

                        VATAmountLine.DeleteAll;
                        CurrReport.CreateTotals("Remaining Amount","VAT Amount",ReminderInterestAmount);
                    end;
                }
                dataitem("Not Due";"Reminder Line")
                {
                    DataItemLink = "Reminder No."=field("No.");
                    DataItemLinkReference = "Reminder Header";
                    DataItemTableView = sorting("Reminder No.","Line No.") where("Line Type"=const("Not Due"));
                    column(ReportForNavId_8300; 8300)
                    {
                    }
                    column(Not_Due__Document_Date_;Format("Document Date"))
                    {
                    }
                    column(Not_Due__Document_Type_;"Document Type")
                    {
                    }
                    column(Not_Due__Document_No__;"Document No.")
                    {
                    }
                    column(Not_Due__Due_Date_;Format("Due Date"))
                    {
                    }
                    column(Not_Due__Original_Amount_;"Original Amount")
                    {
                    }
                    column(Not_Due__Remaining_Amount_;"Remaining Amount")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Not_Due__Type;Type)
                    {
                    }
                    column(Not_Due__Document_Type_Caption;FieldCaption("Document Type"))
                    {
                    }
                    column(Not_Due__Document_No__Caption;FieldCaption("Document No."))
                    {
                    }
                    column(Not_Due__Due_Date_Caption;Not_Due__Due_Date_CaptionLbl)
                    {
                    }
                    column(Not_Due__Original_Amount_Caption;FieldCaption("Original Amount"))
                    {
                    }
                    column(Not_Due__Remaining_Amount_Caption;FieldCaption("Remaining Amount"))
                    {
                    }
                    column(Not_Due__Document_Date_Caption;Not_Due__Document_Date_CaptionLbl)
                    {
                    }
                    column(Open_Entries_Not_DueCaption;Open_Entries_Not_DueCaptionLbl)
                    {
                    }
                }
                dataitem(VATCounter;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_6558; 6558)
                    {
                    }
                    column(VALVATAmount;VALVATAmount)
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATBase;VALVATBase)
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount_;VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base_;VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT___;VATAmountLine."VAT %")
                    {
                    }
                    column(VATAmountLine__Amount_Including_VAT_;VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control51;VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control52;VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control78;VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATBase_Control49;VALVATBase)
                    {
                        AutoFormatExpression = "Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount_Caption;VATAmountLine__VAT_Amount_CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base_Caption;VATAmountLine__VAT_Base_CaptionLbl)
                    {
                    }
                    column(VAT_Amount_SpecificationCaption;VAT_Amount_SpecificationCaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT___Caption;VATAmountLine__VAT___CaptionLbl)
                    {
                    }
                    column(VATAmountLine__Amount_Including_VAT_Caption;VATAmountLine__Amount_Including_VAT_CaptionLbl)
                    {
                    }
                    column(VALVATBase_Control49Caption;VALVATBase_Control49CaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);
                        VALVATBase := VATAmountLine."Amount Including VAT" / (1 + VATAmountLine."VAT %" / 100);
                        VALVATAmount := VATAmountLine."Amount Including VAT" - VALVATBase;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if TotalVATAmount = 0 then
                          CurrReport.Break;
                        SetRange(Number,1,VATAmountLine.Count);
                        CurrReport.CreateTotals(VALVATBase,VALVATAmount);
                    end;
                }
                dataitem(VATCounterLCY;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_2038; 2038)
                    {
                    }
                    column(VALExchRate;VALExchRate)
                    {
                    }
                    column(VALSpecLCYHeader;VALSpecLCYHeader)
                    {
                    }
                    column(VALVATAmountLCY;VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseLCY;VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATAmountLCY_Control114;VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseLCY_Control115;VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT____Control116;VATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(VALVATAmountLCY_Control121;VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseLCY_Control122;VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATAmountLCY_Control114Caption;VALVATAmountLCY_Control114CaptionLbl)
                    {
                    }
                    column(VALVATBaseLCY_Control115Caption;VALVATBaseLCY_Control115CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT____Control116Caption;VATAmountLine__VAT____Control116CaptionLbl)
                    {
                    }
                    column(VALVATBaseLCY_Control122Caption;VALVATBaseLCY_Control122CaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);

                        VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                              "Reminder Header"."Posting Date","Reminder Header"."Currency Code",
                              VALVATBase,CurrFactor));
                        VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                              "Reminder Header"."Posting Date","Reminder Header"."Currency Code",
                              VALVATAmount,CurrFactor));
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (not GLSetup."Print VAT specification in LCY") or
                           ("Reminder Header"."Currency Code" = '') or
                           (VATAmountLine.GetTotalVATAmount = 0)
                        then
                          CurrReport.Break;

                        SetRange(Number,1,VATAmountLine.Count);
                        CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                        if GLSetup."LCY Code" = '' then
                          VALSpecLCYHeader := Text011 + Text012
                        else
                          VALSpecLCYHeader := Text011 + Format(GLSetup."LCY Code");

                        CurrExchRate.FindCurrency("Reminder Header"."Posting Date","Reminder Header"."Currency Code",1);
                        VALExchRate := StrSubstNo(Text013,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                        CurrFactor := CurrExchRate.ExchangeRate("Reminder Header"."Posting Date",
                            "Reminder Header"."Currency Code");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                GLAcc: Record "G/L Account";
                CustPostingGroup: Record "Customer Posting Group";
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                CalcFields("Remaining Amount");
                if "Customer No." = '' then
                  AddError(StrSubstNo(Text000,FieldCaption("Customer No.")))
                else begin
                  if Cust.Get("Customer No.") then begin
                    if Cust.Blocked = Cust.Blocked::All then
                      AddError(
                        StrSubstNo(
                          Text010,
                          Cust.FieldCaption(Blocked),Cust.Blocked,Cust.TableCaption,"Customer No."));
                  end else
                    AddError(
                      StrSubstNo(
                        Text003,
                        Cust.TableCaption,"Customer No."));
                end;

                GLSetup.Get;

                if "Posting Date" = 0D then
                  AddError(StrSubstNo(Text000,FieldCaption("Posting Date")))
                else begin
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
                        Text004,FieldCaption("Posting Date")));
                end;
                if "Document Date" = 0D then
                  AddError(StrSubstNo(Text000,FieldCaption("Document Date")));
                if "Due Date" = 0D then
                  AddError(StrSubstNo(Text000,FieldCaption("Due Date")));
                if "Customer Posting Group" = '' then
                  AddError(StrSubstNo(Text000,FieldCaption("Customer Posting Group")));
                if "Currency Code" = '' then begin
                  GLSetup.TestField("LCY Code");
                  TotalText := StrSubstNo(Text005,GLSetup."LCY Code");
                  TotalInclVATText := StrSubstNo(Text006,GLSetup."LCY Code");
                end else begin
                  TotalText := StrSubstNo(Text005,"Currency Code");
                  TotalInclVATText := StrSubstNo(Text006,"Currency Code");
                end;
                FormatAddr.Reminder(CustAddr,"Reminder Header");
                if "Your Reference" = '' then
                  ReferenceText := ''
                else
                  ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                  VATNoText := ''
                else
                  VATNoText := FieldCaption("VAT Registration No.");

                if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                  AddError(DimMgt.GetDimCombErr);

                TableID[1] := Database::Customer;
                No[1] := "Customer No.";
                if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
                  AddError(DimMgt.GetDimValuePostingErr);

                CalcFields("Additional Fee");
                CustPostingGroup.Get("Customer Posting Group");
                if GLAcc.Get(CustPostingGroup."Additional Fee Account") then begin
                  VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
                  AddFeeInclVAT := "Additional Fee" * (1 + VATPostingSetup."VAT %" / 100);
                end else
                  AddFeeInclVAT := "Additional Fee";

                CalcFields("Add. Fee per Line");
                AddFeePerLineInclVAT := "Add. Fee per Line" + CalculateLineFeeVATAmount;

                CalcFields("Interest Amount","VAT Amount");
                if ("Interest Amount" <> 0) and ("VAT Amount" <> 0) then begin
                  GLAcc.Get(CustPostingGroup."Interest Account");
                  VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
                  VATInterest := VATPostingSetup."VAT %";
                  Interest :=
                    ("Interest Amount" +
                     "VAT Amount" + "Additional Fee" - AddFeeInclVAT + "Add. Fee per Line" - AddFeePerLineInclVAT) / (VATInterest / 100 + 1);
                end else begin
                  Interest := "Interest Amount";
                  VATInterest := 0;
                end;

                NNC_Interest := 0;
                NNC_TotalLCY := 0;
                NNC_VATAmount := 0;
                NNC_TotalLCYVATAmount := 0;
                NNC_RemAmtTotal := 0;
                NNC_VatAmtTotal := 0;
                NNC_ReminderInterestAmt := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowDimensions;ShowDim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Dimensions';
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

    trigger OnInitReport()
    begin
        GLSetup.Get;
    end;

    trigger OnPreReport()
    begin
        ReminderHeaderFilter := "Reminder Header".GetFilters;
    end;

    var
        Text000: label '%1 must be specified.';
        Text003: label '%1 %2 does not exist.';
        Text004: label '%1 is not within your allowed range of posting dates.';
        Text005: label 'Total %1';
        Text006: label 'Total %1 Incl. Tax';
        Text008: label 'Reminder: %1';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        DimMgt: Codeunit DimensionManagement;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array [8] of Text[50];
        ReminderHeaderFilter: Text;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        ReminderInterestAmount: Decimal;
        Continue: Boolean;
        VATNoText: Text[30];
        ReferenceText: Text[30];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        ErrorCounter: Integer;
        ErrorText: array [99] of Text[250];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowDim: Boolean;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        Text010: label '%1 must not be %2 for %3 %4.';
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text011: label 'Tax Amount Specification in ';
        Text012: label 'Local Currency';
        Text013: label 'Exchange rate: %1/%2';
        CurrFactor: Decimal;
        TotalVATAmount: Decimal;
        AddFeeInclVAT: Decimal;
        AddFeePerLineInclVAT: Decimal;
        VATInterest: Decimal;
        Interest: Decimal;
        VALVATBase: Decimal;
        VALVATAmount: Decimal;
        NNC_Interest: Decimal;
        NNC_TotalLCY: Decimal;
        NNC_VATAmount: Decimal;
        NNC_TotalLCYVATAmount: Decimal;
        NNC_RemAmtTotal: Decimal;
        NNC_VatAmtTotal: Decimal;
        NNC_ReminderInterestAmt: Decimal;
        TextPageLbl: label 'Page';
        Reminder___TestCaptionLbl: label 'Reminder - Test';
        Reminder_Header___Document_Date_CaptionLbl: label 'Document Date';
        Reminder_Header___Posting_Date_CaptionLbl: label 'Posting Date';
        Reminder_Header___Due_Date_CaptionLbl: label 'Due Date';
        Tax_Ident__TypeCaptionLbl: label 'Tax Ident. Type';
        Header_DimensionsCaptionLbl: label 'Header Dimensions';
        ErrorText_Number_CaptionLbl: label 'Warning!';
        Text009Lbl: label 'Interests must be positive or 0.';
        Reminder_Line__Due_Date_CaptionLbl: label 'Due Date';
        Reminder_Line__Document_Date_CaptionLbl: label 'Document Date';
        Text009CaptionLbl: label 'Warning!';
        ReminderInterestAmount_VATInterest_100__1_CaptionLbl: label 'Interest Amount';
        VAT_AmountCaptionLbl: label 'Tax Amount';
        ErrorText_Number__Control97CaptionLbl: label 'Warning!';
        Not_Due__Due_Date_CaptionLbl: label 'Due Date>';
        Not_Due__Document_Date_CaptionLbl: label 'Document Date';
        Open_Entries_Not_DueCaptionLbl: label 'Open Entries Not Due';
        VATAmountLine__VAT_Amount_CaptionLbl: label 'Tax Amount';
        VATAmountLine__VAT_Base_CaptionLbl: label 'Tax Base';
        VAT_Amount_SpecificationCaptionLbl: label 'Tax Amount Specification';
        VATAmountLine__VAT___CaptionLbl: label 'Tax %';
        VATAmountLine__Amount_Including_VAT_CaptionLbl: label 'Amount Including Tax';
        VALVATBase_Control49CaptionLbl: label 'Total';
        VALVATAmountLCY_Control114CaptionLbl: label 'Tax Amount';
        VALVATBaseLCY_Control115CaptionLbl: label 'Tax Base';
        VATAmountLine__VAT____Control116CaptionLbl: label 'Tax %';
        VALVATBaseLCY_Control122CaptionLbl: label 'Total';

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

