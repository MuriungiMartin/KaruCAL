#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1401 Check
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check.rdlc';
    Caption = 'Check';
    Permissions = TableData "Bank Account"=m;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(VoidGenJnlLine;"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
            RequestFilterFields = "Journal Template Name","Journal Batch Name","Posting Date";
            column(ReportForNavId_9788; 9788)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                if CurrReport.Preview then
                  Error(Text000);

                if UseCheckNo = '' then
                  Error(Text001);

                if TestPrint then
                  CurrReport.Break;

                if not ReprintChecks then
                  CurrReport.Break;

                if (GetFilter("Line No.") <> '') or (GetFilter("Document No.") <> '') then
                  Error(
                    Text002,FieldCaption("Line No."),FieldCaption("Document No."));
                SetRange("Bank Payment Type","bank payment type"::"Computer Check");
                SetRange("Check Printed",true);
            end;
        }
        dataitem(GenJnlLine;"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
            column(ReportForNavId_3808; 3808)
            {
            }
            column(JournalTempName_GenJnlLine;"Journal Template Name")
            {
            }
            column(JournalBatchName_GenJnlLine;"Journal Batch Name")
            {
            }
            column(LineNo_GenJnlLine;"Line No.")
            {
            }
            column(PostingDate_GenJnlLine;GenJnlLine."Posting Date")
            {
            }
            column(Description_GenJnlLine;GenJnlLine.Description)
            {
            }
            column(Amount_GenJnlLine;GenJnlLine.Amount)
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(ChkAmount;ChkAmount)
            {
            }
            column(ChkAmount_txt;ChkAmount_txt)
            {
            }
            dataitem(CheckPages;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1159; 1159)
                {
                }
                column(CheckToAddr1;CheckToAddr[1])
                {
                }
                column(CheckDateText;CheckDateText)
                {
                }
                column(CheckNoText;CheckNoText)
                {
                }
                column(FirstPage;FirstPage)
                {
                }
                column(PreprintedStub;PreprintedStub)
                {
                }
                column(CheckNoTextCaption;CheckNoTextCaptionLbl)
                {
                }
                dataitem(PrintSettledLoop;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 30;
                    column(ReportForNavId_4098; 4098)
                    {
                    }
                    column(NetAmount;NetAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalLineDiscountLineDiscount;TotalLineDiscount - LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalLineAmountLineAmount;TotalLineAmount - LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalLineAmountLineAmount2;TotalLineAmount - LineAmount2)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount;LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineDiscount;LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmountLineDiscount;LineAmount + LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(DocNo;DocNo)
                    {
                    }
                    column(DocDate;DocDate)
                    {
                    }
                    column(CurrencyCode2;CurrencyCode2)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CurrentLineAmount;CurrentLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(ExtDocNo;ExtDocNo)
                    {
                    }
                    column(LineAmountCaption;LineAmountCaptionLbl)
                    {
                    }
                    column(LineDiscountCaption;LineDiscountCaptionLbl)
                    {
                    }
                    column(AmountCaption;AmountCaptionLbl)
                    {
                    }
                    column(DocNoCaption;DocNoCaptionLbl)
                    {
                    }
                    column(DocDateCaption;DocDateCaptionLbl)
                    {
                    }
                    column(CurrencyCodeCaption;CurrencyCodeCaptionLbl)
                    {
                    }
                    column(YourDocNoCaption;YourDocNoCaptionLbl)
                    {
                    }
                    column(TransportCaption;TransportCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not TestPrint then begin
                          if FoundLast then begin
                            if RemainingAmount <> 0 then begin
                              DocType := Text015;
                              DocNo := '';
                              ExtDocNo := '';
                              DocDate := 0D;
                              LineAmount := RemainingAmount;
                              LineAmount2 := RemainingAmount;
                              CurrentLineAmount := LineAmount2;
                              LineDiscount := 0;
                              RemainingAmount := 0;
                            end else
                              CurrReport.Break;
                          end else
                            case ApplyMethod of
                              Applymethod::OneLineOneEntry:
                                begin
                                  case BalancingType of
                                    Balancingtype::Customer:
                                      begin
                                        CustLedgEntry.Reset;
                                        CustLedgEntry.SetCurrentkey("Document No.");
                                        CustLedgEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
                                        CustLedgEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
                                        CustLedgEntry.SetRange("Customer No.",BalancingNo);
                                        CustLedgEntry.Find('-');
                                        CustUpdateAmounts(CustLedgEntry,RemainingAmount);
                                      end;
                                    Balancingtype::Vendor:
                                      begin
                                        VendLedgEntry.Reset;
                                        VendLedgEntry.SetCurrentkey("Document No.");
                                        VendLedgEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
                                        VendLedgEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
                                        VendLedgEntry.SetRange("Vendor No.",BalancingNo);
                                        VendLedgEntry.Find('-');
                                        VendUpdateAmounts(VendLedgEntry,RemainingAmount);
                                      end;
                                  end;
                                  RemainingAmount := RemainingAmount - LineAmount2;
                                  CurrentLineAmount := LineAmount2;
                                  FoundLast := true;
                                end;
                              Applymethod::OneLineID:
                                begin
                                  case BalancingType of
                                    Balancingtype::Customer:
                                      begin
                                        CustUpdateAmounts(CustLedgEntry,RemainingAmount);
                                        FoundLast := (CustLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                        if FoundLast and not FoundNegative then begin
                                          CustLedgEntry.SetRange(Positive,false);
                                          FoundLast := not CustLedgEntry.Find('-');
                                          FoundNegative := true;
                                        end;
                                      end;
                                    Balancingtype::Vendor:
                                      begin
                                        VendUpdateAmounts(VendLedgEntry,RemainingAmount);
                                        FoundLast := (VendLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                        if FoundLast and not FoundNegative then begin
                                          VendLedgEntry.SetRange(Positive,false);
                                          FoundLast := not VendLedgEntry.Find('-');
                                          FoundNegative := true;
                                        end;
                                      end;
                                  end;
                                  RemainingAmount := RemainingAmount - LineAmount2;
                                  CurrentLineAmount := LineAmount2;
                                end;
                              Applymethod::MoreLinesOneEntry:
                                begin
                                  CurrentLineAmount := GenJnlLine2.Amount;
                                  LineAmount2 := CurrentLineAmount;

                                  if GenJnlLine2."Applies-to ID" <> '' then
                                    Error(Text016);
                                  GenJnlLine2.TestField("Check Printed",false);
                                  GenJnlLine2.TestField("Bank Payment Type",GenJnlLine2."bank payment type"::"Computer Check");
                                  if BankAcc2."Currency Code" <> GenJnlLine2."Currency Code" then
                                    Error(Text005);
                                  if GenJnlLine2."Applies-to Doc. No." = '' then begin
                                    DocType := Text015;
                                    DocNo := '';
                                    ExtDocNo := '';
                                    DocDate := 0D;
                                    LineAmount := CurrentLineAmount;
                                    LineDiscount := 0;
                                  end else
                                    case BalancingType of
                                      Balancingtype::"G/L Account":
                                        begin
                                          DocType := Format(GenJnlLine2."Document Type");
                                          DocNo := GenJnlLine2."Document No.";
                                          ExtDocNo := GenJnlLine2."External Document No.";
                                          LineAmount := CurrentLineAmount;
                                          LineDiscount := 0;
                                        end;
                                      Balancingtype::Customer:
                                        begin
                                          CustLedgEntry.Reset;
                                          CustLedgEntry.SetCurrentkey("Document No.");
                                          CustLedgEntry.SetRange("Document Type",GenJnlLine2."Applies-to Doc. Type");
                                          CustLedgEntry.SetRange("Document No.",GenJnlLine2."Applies-to Doc. No.");
                                          CustLedgEntry.SetRange("Customer No.",BalancingNo);
                                          CustLedgEntry.Find('-');
                                          CustUpdateAmounts(CustLedgEntry,CurrentLineAmount);
                                          LineAmount := CurrentLineAmount;
                                        end;
                                      Balancingtype::Vendor:
                                        begin
                                          VendLedgEntry.Reset;
                                          if GenJnlLine2."Source Line No." <> 0 then
                                            VendLedgEntry.SetRange("Entry No.",GenJnlLine2."Source Line No.")
                                          else begin
                                            VendLedgEntry.SetCurrentkey("Document No.");
                                            VendLedgEntry.SetRange("Document Type",GenJnlLine2."Applies-to Doc. Type");
                                            VendLedgEntry.SetRange("Document No.",GenJnlLine2."Applies-to Doc. No.");
                                            VendLedgEntry.SetRange("Vendor No.",BalancingNo);
                                          end;
                                          VendLedgEntry.Find('-');
                                          VendUpdateAmounts(VendLedgEntry,CurrentLineAmount);
                                          LineAmount := CurrentLineAmount;
                                        end;
                                      Balancingtype::"Bank Account":
                                        begin
                                          DocType := Format(GenJnlLine2."Document Type");
                                          DocNo := GenJnlLine2."Document No.";
                                          ExtDocNo := GenJnlLine2."External Document No.";
                                          LineAmount := CurrentLineAmount;
                                          LineDiscount := 0;
                                        end;
                                    end;
                                  FoundLast := GenJnlLine2.Next = 0;
                                end;
                            end;

                          TotalLineAmount := TotalLineAmount + LineAmount2;
                          TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        end else begin
                          if FoundLast then
                            CurrReport.Break;
                          FoundLast := true;
                          DocType := Text018;
                          DocNo := Text010;
                          ExtDocNo := Text010;
                          LineAmount := 0;
                          LineDiscount := 0;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not TestPrint then
                          if FirstPage then begin
                            FoundLast := true;
                            case ApplyMethod of
                              Applymethod::OneLineOneEntry:
                                FoundLast := false;
                              Applymethod::OneLineID:
                                case BalancingType of
                                  Balancingtype::Customer:
                                    begin
                                      CustLedgEntry.Reset;
                                      CustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
                                      CustLedgEntry.SetRange("Customer No.",BalancingNo);
                                      CustLedgEntry.SetRange(Open,true);
                                      CustLedgEntry.SetRange(Positive,true);
                                      CustLedgEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");
                                      FoundLast := not CustLedgEntry.Find('-');
                                      if FoundLast then begin
                                        CustLedgEntry.SetRange(Positive,false);
                                        FoundLast := not CustLedgEntry.Find('-');
                                        FoundNegative := true;
                                      end else
                                        FoundNegative := false;
                                    end;
                                  Balancingtype::Vendor:
                                    begin
                                      VendLedgEntry.Reset;
                                      VendLedgEntry.SetCurrentkey("Vendor No.",Open,Positive);
                                      VendLedgEntry.SetRange("Vendor No.",BalancingNo);
                                      VendLedgEntry.SetRange(Open,true);
                                      VendLedgEntry.SetRange(Positive,true);
                                      VendLedgEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");
                                      FoundLast := not VendLedgEntry.Find('-');
                                      if FoundLast then begin
                                        VendLedgEntry.SetRange(Positive,false);
                                        FoundLast := not VendLedgEntry.Find('-');
                                        FoundNegative := true;
                                      end else
                                        FoundNegative := false;
                                    end;
                                end;
                              Applymethod::MoreLinesOneEntry:
                                FoundLast := false;
                            end;
                          end
                          else
                            FoundLast := false;

                        if DocNo = '' then
                          CurrencyCode2 := GenJnlLine."Currency Code";

                        if PreprintedStub then
                          TotalText := ''
                        else
                          TotalText := Text019;

                        if GenJnlLine."Currency Code" <> '' then
                          NetAmount := StrSubstNo(Text063,GenJnlLine."Currency Code")
                        else begin
                          GLSetup.Get;
                          NetAmount := StrSubstNo(Text063,GLSetup."LCY Code");
                        end;
                    end;
                }
                dataitem(PrintCheck;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;
                    column(ReportForNavId_3931; 3931)
                    {
                    }
                    column(CheckAmountText;CheckAmountText)
                    {
                    }
                    column(CheckDateTextControl2;CheckDateText)
                    {
                    }
                    column(DescriptionLine2;DescriptionLine[2])
                    {
                    }
                    column(DescriptionLine1;DescriptionLine[1])
                    {
                    }
                    column(CheckToAddr1Control7;CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr2;CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr4;CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr3;CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr5;CheckToAddr[5])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr8;CompanyAddr[8])
                    {
                    }
                    column(CompanyAddr7;CompanyAddr[7])
                    {
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(CheckNoTextControl21;CheckNoText)
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(TotalLineAmount;TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText;TotalText)
                    {
                    }
                    column(VoidText;VoidText)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        Decimals: Decimal;
                    begin
                        if not TestPrint then begin
                          with GenJnlLine do begin
                            CheckLedgEntry.Init;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := "Posting Date";
                            CheckLedgEntry."Document Type" := "Document Type";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := Description;
                            CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type" := BalancingType;
                            CheckLedgEntry."Bal. Account No." := BalancingNo;
                            if FoundLast then begin
                              if TotalLineAmount <= 0 then
                                Error(
                                  Text020,
                                  UseCheckNo,TotalLineAmount);
                              CheckLedgEntry."Entry Status" := CheckLedgEntry."entry status"::Printed;
                              CheckLedgEntry.Amount := TotalLineAmount;
                            end else begin
                              CheckLedgEntry."Entry Status" := CheckLedgEntry."entry status"::Voided;
                              CheckLedgEntry.Amount := 0;
                            end;
                            CheckLedgEntry."Check Date" := "Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            //CheckManagement.InsertCheck(CheckLedgEntrRecordIdToPrint);

                            if FoundLast then begin
                              if BankAcc2."Currency Code" <> '' then
                                Currency.Get(BankAcc2."Currency Code")
                              else
                                Currency.InitRoundingPrecision;
                              Decimals := CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount,1,'<');
                              if StrLen(Format(Decimals)) < StrLen(Format(Currency."Amount Rounding Precision")) then
                                if Decimals = 0 then
                                  CheckAmountText := Format(CheckLedgEntry.Amount,0,0) +
                                    CopyStr(Format(0.01),2,1) +
                                    PadStr('',StrLen(Format(Currency."Amount Rounding Precision")) - 2,'0')
                                else
                                  CheckAmountText := Format(CheckLedgEntry.Amount,0,0) +
                                    PadStr('',StrLen(Format(Currency."Amount Rounding Precision")) - StrLen(Format(Decimals)),'0')
                              else
                                CheckAmountText := Format(CheckLedgEntry.Amount,0,0);
                              FormatNoText(DescriptionLine,CheckLedgEntry.Amount,BankAcc2."Currency Code");
                              VoidText := '';
                            end else begin
                              Clear(CheckAmountText);
                              Clear(DescriptionLine);
                              TotalText := Text065;
                              DescriptionLine[1] := Text021;
                              DescriptionLine[2] := DescriptionLine[1];
                              VoidText := Text022;
                            end;
                          end;
                        end else
                          with GenJnlLine do begin
                            CheckLedgEntry.Init;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := "Posting Date";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := Text023;
                            CheckLedgEntry."Bank Payment Type" := "bank payment type"::"Computer Check";
                            CheckLedgEntry."Entry Status" := CheckLedgEntry."entry status"::"Test Print";
                            CheckLedgEntry."Check Date" := "Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                           // CheckManagement.InsertCheck(CheckLedgEntry);

                            CheckAmountText := Text024;
                            DescriptionLine[1] := Text025;
                            DescriptionLine[2] := DescriptionLine[1];
                            VoidText := Text022;
                          end;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := false;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if FoundLast then
                      CurrReport.Break;

                    UseCheckNo := IncStr(UseCheckNo);
                    if not TestPrint then
                      CheckNoText := UseCheckNo
                    else
                      CheckNoText := Text011;
                end;

                trigger OnPostDataItem()
                begin
                    if not TestPrint then begin
                      if UseCheckNo <> GenJnlLine."Document No." then begin
                        GenJnlLine3.Reset;
                        GenJnlLine3.SetCurrentkey("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
                        GenJnlLine3.SetRange("Journal Template Name",GenJnlLine."Journal Template Name");
                        GenJnlLine3.SetRange("Journal Batch Name",GenJnlLine."Journal Batch Name");
                        GenJnlLine3.SetRange("Posting Date",GenJnlLine."Posting Date");
                        GenJnlLine3.SetRange("Document No.",UseCheckNo);
                        if GenJnlLine3.Find('-') then
                          GenJnlLine3.FieldError("Document No.",StrSubstNo(Text013,UseCheckNo));
                      end;

                      if ApplyMethod <> Applymethod::MoreLinesOneEntry then begin
                        GenJnlLine3 := GenJnlLine;
                        GenJnlLine3.TestField("Posting No. Series",'');
                        GenJnlLine3."Document No." := UseCheckNo;
                        GenJnlLine3."Check Printed" := true;
                        GenJnlLine3.Modify;
                      end else begin
                        if GenJnlLine2.Find('-') then begin
                          HighestLineNo := GenJnlLine2."Line No.";
                          repeat
                            if GenJnlLine2."Line No." > HighestLineNo then
                              HighestLineNo := GenJnlLine2."Line No.";
                            GenJnlLine3 := GenJnlLine2;
                            GenJnlLine3.TestField("Posting No. Series",'');
                            GenJnlLine3."Bal. Account No." := '';
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."bank payment type"::" ";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3.Validate(Amount);
                            GenJnlLine3.Modify;
                          until GenJnlLine2.Next = 0;
                        end;

                        GenJnlLine3.Reset;
                        GenJnlLine3 := GenJnlLine;
                        GenJnlLine3.SetRange("Journal Template Name",GenJnlLine."Journal Template Name");
                        GenJnlLine3.SetRange("Journal Batch Name",GenJnlLine."Journal Batch Name");
                        GenJnlLine3."Line No." := HighestLineNo;
                        if GenJnlLine3.Next = 0 then
                          GenJnlLine3."Line No." := HighestLineNo + 10000
                        else begin
                          while GenJnlLine3."Line No." = HighestLineNo + 1 do begin
                            HighestLineNo := GenJnlLine3."Line No.";
                            if GenJnlLine3.Next = 0 then
                              GenJnlLine3."Line No." := HighestLineNo + 20000;
                          end;
                          GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                        end;
                        GenJnlLine3.Init;
                        GenJnlLine3.Validate("Posting Date",GenJnlLine."Posting Date");
                        GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                        GenJnlLine3."Document No." := UseCheckNo;
                        GenJnlLine3."Account Type" := GenJnlLine3."account type"::"Bank Account";
                        GenJnlLine3.Validate("Account No.",BankAcc2."No.");
                        if BalancingType <> Balancingtype::"G/L Account" then
                          GenJnlLine3.Description := StrSubstNo(Text014,SelectStr(BalancingType + 1,Text062),BalancingNo);
                        GenJnlLine3.Validate(Amount,-TotalLineAmount);
                        GenJnlLine3."Bank Payment Type" := GenJnlLine3."bank payment type"::"Computer Check";
                        GenJnlLine3."Check Printed" := true;
                        GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                        GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                        GenJnlLine3."Allow Zero-Amount Posting" := true;
                        GenJnlLine3.Insert;
                      end;
                    end;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.Modify;

                    Clear(CheckManagement);
                end;

                trigger OnPreDataItem()
                begin
                    FirstPage := true;
                    FoundLast := false;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if OneCheckPrVendor and ("Currency Code" <> '') and
                   ("Currency Code" <> Currency.Code)
                then begin
                  Currency.Get("Currency Code");
                  Currency.TestField("Conv. LCY Rndg. Debit Acc.");
                  Currency.TestField("Conv. LCY Rndg. Credit Acc.");
                end;

                if not TestPrint then begin
                  if Amount = 0 then
                    CurrReport.Skip;

                  TestField("Bal. Account Type","bal. account type"::"Bank Account");
                  if "Bal. Account No." <> BankAcc2."No." then
                    CurrReport.Skip;

                  if ("Account No." <> '') and ("Bal. Account No." <> '') then begin
                    BalancingType := "Account Type";
                    BalancingNo := "Account No.";
                    RemainingAmount := Amount;
                    if OneCheckPrVendor then begin
                      ApplyMethod := Applymethod::MoreLinesOneEntry;
                      GenJnlLine2.Reset;
                      GenJnlLine2.SetCurrentkey("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
                      GenJnlLine2.SetRange("Journal Template Name","Journal Template Name");
                      GenJnlLine2.SetRange("Journal Batch Name","Journal Batch Name");
                      GenJnlLine2.SetRange("Posting Date","Posting Date");
                      GenJnlLine2.SetRange("Document No.","Document No.");
                      GenJnlLine2.SetRange("Account Type","Account Type");
                      GenJnlLine2.SetRange("Account No.","Account No.");
                      GenJnlLine2.SetRange("Bal. Account Type","Bal. Account Type");
                      GenJnlLine2.SetRange("Bal. Account No.","Bal. Account No.");
                      GenJnlLine2.SetRange("Bank Payment Type","Bank Payment Type");
                      GenJnlLine2.Find('-');
                      RemainingAmount := 0;
                    end else
                      if "Applies-to Doc. No." <> '' then
                        ApplyMethod := Applymethod::OneLineOneEntry
                      else
                        if "Applies-to ID" <> '' then
                          ApplyMethod := Applymethod::OneLineID
                        else
                          ApplyMethod := Applymethod::Payment;
                  end else
                    if "Account No." = '' then
                      FieldError("Account No.",Text004)
                    else
                      FieldError("Bal. Account No.",Text004);

                  Clear(CheckToAddr);
                  ContactText := '';
                  Clear(SalesPurchPerson);
                  case BalancingType of
                    Balancingtype::"G/L Account":
                      CheckToAddr[1] := Description;
                    Balancingtype::Customer:
                      begin
                        Cust.Get(BalancingNo);
                        if Cust.Blocked = Cust.Blocked::All then
                          Error(Text064,Cust.FieldCaption(Blocked),Cust.Blocked,Cust.TableCaption,Cust."No.");
                        Cust.Contact := '';
                        FormatAddr.Customer(CheckToAddr,Cust);
                        if BankAcc2."Currency Code" <> "Currency Code" then
                          Error(Text005);
                        if Cust."Salesperson Code" <> '' then begin
                          ContactText := Text006;
                          SalesPurchPerson.Get(Cust."Salesperson Code");
                        end;
                      end;
                    Balancingtype::Vendor:
                      begin
                        Vend.Get(BalancingNo);
                        if Vend.Blocked in [Vend.Blocked::All,Vend.Blocked::Payment] then
                          Error(Text064,Vend.FieldCaption(Blocked),Vend.Blocked,Vend.TableCaption,Vend."No.");
                        Vend.Contact := '';
                        FormatAddr.Vendor(CheckToAddr,Vend);
                        if BankAcc2."Currency Code" <> "Currency Code" then
                          Error(Text005);
                        if Vend."Purchaser Code" <> '' then begin
                          ContactText := Text007;
                          SalesPurchPerson.Get(Vend."Purchaser Code");
                        end;
                      end;
                    Balancingtype::"Bank Account":
                      begin
                        BankAcc.Get(BalancingNo);
                        BankAcc.TestField(Blocked,false);
                        BankAcc.Contact := '';
                        FormatAddr.BankAcc(CheckToAddr,BankAcc);
                        if BankAcc2."Currency Code" <> BankAcc."Currency Code" then
                          Error(Text008);
                        if BankAcc."Our Contact Code" <> '' then begin
                          ContactText := Text009;
                          SalesPurchPerson.Get(BankAcc."Our Contact Code");
                        end;
                      end;
                  end;

                  CheckDateText := Format("Posting Date",0,4);
                end else begin
                  if ChecksPrinted > 0 then
                    CurrReport.Break;
                  BalancingType := Balancingtype::Vendor;
                  BalancingNo := Text010;
                  Clear(CheckToAddr);
                  for i := 1 to 5 do
                    CheckToAddr[i] := Text003;
                  ContactText := '';
                  Clear(SalesPurchPerson);
                  CheckNoText := Text011;
                  CheckDateText := Text012;
                end;
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText,GenJnlLine.Amount,'');

                ChkAmount:=GenJnlLine.Amount;
                ChkAmount_txt:= Format(ChkAmount);
                if StrPos(ChkAmount_txt,'.')=0 then
                ChkAmount_txt:=ChkAmount_txt+'.00';

                if StrLen(CopyStr(ChkAmount_txt,StrPos(ChkAmount_txt,'.'),StrLen(ChkAmount_txt)))=2 then

                ChkAmount_txt:=ChkAmount_txt+'0';
            end;

            trigger OnPreDataItem()
            begin
                Copy(VoidGenJnlLine);
                CompanyInfo.Get;
                if not TestPrint then begin
                  FormatAddr.Company(CompanyAddr,CompanyInfo);
                  BankAcc2.Get(BankAcc2."No.");
                  BankAcc2.TestField(Blocked,false);
                  Copy(VoidGenJnlLine);
                  SetRange("Bank Payment Type","bank payment type"::"Computer Check");
                  SetRange("Check Printed",false);
                end else begin
                  Clear(CompanyAddr);
                  for i := 1 to 5 do
                    CompanyAddr[i] := Text003;
                end;
                ChecksPrinted := 0;

                SetRange("Account Type","account type"::"Fixed Asset");
                if Find('-') then
                  FieldError("Account Type");
                SetRange("Account Type");
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
                    field(BankAccount;BankAcc2."No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bank Account';
                        TableRelation = "Bank Account";

                        trigger OnValidate()
                        begin
                            InputBankAccount;
                        end;
                    }
                    field(LastCheckNo;UseCheckNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Last Check No.';
                    }
                    field(OneCheckPrVendor;OneCheckPrVendor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'One Check per Vendor per Document No.';
                        MultiLine = true;
                    }
                    field(ReprintChecks;ReprintChecks)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reprint Checks';
                    }
                    field(TestPrinting;TestPrint)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Test Print';
                    }
                    field(PreprintedStub;PreprintedStub)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Preprinted Stub';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if BankAcc2."No." <> '' then
              if BankAcc2.Get(BankAcc2."No.") then
                UseCheckNo := BankAcc2."Last Check No."
              else begin
                BankAcc2."No." := '';
                UseCheckNo := '';
              end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        InitTextVariable;
    end;

    var
        Text000: label 'Preview is not allowed.';
        Text001: label 'Last Check No. must be filled in.';
        Text002: label 'Filters on %1 and %2 are not allowed.';
        Text003: label 'XXXXXXXXXXXXXXXX';
        Text004: label 'must be entered.';
        Text005: label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: label 'Salesperson';
        Text007: label 'Purchaser';
        Text008: label 'Both Bank Accounts must have the same currency.';
        Text009: label 'Our Contact';
        Text010: label 'XXXXXXXXXX';
        Text011: label 'XXXX';
        Text012: label 'XX.XXXXXXXXXX.XXXX';
        Text013: label '%1 already exists.';
        Text014: label 'Check for %1 %2';
        Text015: label 'Payment';
        Text016: label 'In the Check report, One Check per Vendor and Document No.\must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: label 'XXX';
        Text019: label 'Total';
        Text020: label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: label 'NON-NEGOTIABLE';
        Text023: label 'Test print';
        Text024: label 'XXXX.XX';
        Text025: label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: label 'ZERO';
        Text027: label 'HUNDRED';
        Text028: label 'AND';
        Text029: label '%1 results in a written number that is too long.';
        Text030: label ' is already applied to %1 %2 for customer %3.';
        Text031: label ' is already applied to %1 %2 for vendor %3.';
        Text032: label 'ONE';
        Text033: label 'TWO';
        Text034: label 'THREE';
        Text035: label 'FOUR';
        Text036: label 'FIVE';
        Text037: label 'SIX';
        Text038: label 'SEVEN';
        Text039: label 'EIGHT';
        Text040: label 'NINE';
        Text041: label 'TEN';
        Text042: label 'ELEVEN';
        Text043: label 'TWELVE';
        Text044: label 'THIRTEEN';
        Text045: label 'FOURTEEN';
        Text046: label 'FIFTEEN';
        Text047: label 'SIXTEEN';
        Text048: label 'SEVENTEEN';
        Text049: label 'EIGHTEEN';
        Text050: label 'NINETEEN';
        Text051: label 'TWENTY';
        Text052: label 'THIRTY';
        Text053: label 'FORTY';
        Text054: label 'FIFTY';
        Text055: label 'SIXTY';
        Text056: label 'SEVENTY';
        Text057: label 'EIGHTY';
        Text058: label 'NINETY';
        Text059: label 'THOUSAND';
        Text060: label 'MILLION';
        Text061: label 'BILLION';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        CompanyAddr: array [8] of Text[50];
        CheckToAddr: array [8] of Text[50];
        OnesText: array [20] of Text[30];
        TensText: array [10] of Text[30];
        ExponentText: array [5] of Text[30];
        BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array [2] of Text[80];
        DocType: Text[30];
        DocNo: Text[30];
        ExtDocNo: Text[35];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        Text062: label 'G/L Account,Customer,Vendor,Bank Account';
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LineAmount2: Decimal;
        Text063: label 'Net Amount %1';
        GLSetup: Record "General Ledger Setup";
        Text064: label '%1 must not be %2 for %3 %4.';
        Text065: label 'Subtotal';
        CheckNoTextCaptionLbl: label 'Check No.';
        LineAmountCaptionLbl: label 'Net Amount';
        LineDiscountCaptionLbl: label 'Discount';
        AmountCaptionLbl: label 'Amount';
        DocNoCaptionLbl: label 'Document No.';
        DocDateCaptionLbl: label 'Document Date';
        CurrencyCodeCaptionLbl: label 'Currency Code';
        YourDocNoCaptionLbl: label 'Your Doc. No.';
        TransportCaptionLbl: label 'Transport';
        NumberText: array [2] of Text[120];
        CheckReport: Report Check;
        ChkAmount: Decimal;
        ChkAmount_txt: Text[30];


    procedure FormatNoText(var NoText: array [2] of Text[80];No: Decimal;CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '***';
        GLSetup.Get;

        if No < 1 then
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text026)
        else
          for Exponent := 4 downto 1 do begin
            PrintExponent := false;
            Ones := No DIV Power(1000,Exponent - 1);
            Hundreds := Ones DIV 100;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            if Hundreds > 0 then begin
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text027);
            end;
            if Tens >= 2 then begin
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              if Ones > 0 then
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            end else
              if (Tens * 10 + Ones) > 0 then
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            if PrintExponent and (Exponent > 1) then
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000,Exponent - 1);
          end;

        AddToNoText(NoText,NoTextIndex,PrintExponent,Text028);
        if GLSetup."Amount Rounding Precision" <> 0 then
          DecimalPosition := 1 / GLSetup."Amount Rounding Precision"
        else
          DecimalPosition := 1;
        AddToNoText(NoText,NoTextIndex,PrintExponent,(Format(No * DecimalPosition) + '/' + Format(DecimalPosition)));

        if CurrencyCode <> '' then
          AddToNoText(NoText,NoTextIndex,PrintExponent,CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array [2] of Text[80];var NoTextIndex: Integer;var PrintExponent: Boolean;AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
          NoTextIndex := NoTextIndex + 1;
          if NoTextIndex > ArrayLen(NoText) then
            Error(Text029,AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText,'<');
    end;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry";RemainingAmount2: Decimal)
    begin
        if (ApplyMethod = Applymethod::OneLineOneEntry) or
           (ApplyMethod = Applymethod::MoreLinesOneEntry)
        then begin
          GenJnlLine3.Reset;
          GenJnlLine3.SetCurrentkey(
            "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
          GenJnlLine3.SetRange("Account Type",GenJnlLine3."account type"::Customer);
          GenJnlLine3.SetRange("Account No.",CustLedgEntry2."Customer No.");
          GenJnlLine3.SetRange("Applies-to Doc. Type",CustLedgEntry2."Document Type");
          GenJnlLine3.SetRange("Applies-to Doc. No.",CustLedgEntry2."Document No.");
          if ApplyMethod = Applymethod::OneLineOneEntry then
            GenJnlLine3.SetFilter("Line No.",'<>%1',GenJnlLine."Line No.")
          else
            GenJnlLine3.SetFilter("Line No.",'<>%1',GenJnlLine2."Line No.");
          if CustLedgEntry2."Document Type" <> CustLedgEntry2."document type"::" " then
            if GenJnlLine3.Find('-') then
              GenJnlLine3.FieldError(
                "Applies-to Doc. No.",
                StrSubstNo(
                  Text030,
                  CustLedgEntry2."Document Type",CustLedgEntry2."Document No.",
                  CustLedgEntry2."Customer No."));
        end;

        DocType := Format(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Posting Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";

        CustLedgEntry2.CalcFields("Remaining Amount");

        LineAmount :=
          -ABSMin(
            CustLedgEntry2."Remaining Amount" -
            CustLedgEntry2."Remaining Pmt. Disc. Possible" -
            CustLedgEntry2."Accepted Payment Tolerance",
            CustLedgEntry2."Amount to Apply");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,LineAmount),
            Currency."Amount Rounding Precision");

        if ((CustLedgEntry2."Document Type" in [CustLedgEntry2."document type"::Invoice,
                                                CustLedgEntry2."document type"::"Credit Memo"]) and
            (CustLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) and
            (CustLedgEntry2."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) or
           CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
          LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
          if CustLedgEntry2."Accepted Payment Tolerance" <> 0 then
            LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        end else begin
          if RemainingAmount2 >=
             ROUND(
               -ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                 CustLedgEntry2."Amount to Apply"),Currency."Amount Rounding Precision")
          then
            LineAmount2 :=
              ROUND(
                -ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                  CustLedgEntry2."Amount to Apply"),Currency."Amount Rounding Precision")
          else begin
            LineAmount2 := RemainingAmount2;
            LineAmount :=
              ROUND(
                ExchangeAmt(CustLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                  LineAmount2),Currency."Amount Rounding Precision");
          end;
          LineDiscount := 0;
        end;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry";RemainingAmount2: Decimal)
    begin
        if (ApplyMethod = Applymethod::OneLineOneEntry) or
           (ApplyMethod = Applymethod::MoreLinesOneEntry)
        then begin
          GenJnlLine3.Reset;
          GenJnlLine3.SetCurrentkey(
            "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
          GenJnlLine3.SetRange("Account Type",GenJnlLine3."account type"::Vendor);
          GenJnlLine3.SetRange("Account No.",VendLedgEntry2."Vendor No.");
          GenJnlLine3.SetRange("Applies-to Doc. Type",VendLedgEntry2."Document Type");
          GenJnlLine3.SetRange("Applies-to Doc. No.",VendLedgEntry2."Document No.");
          if ApplyMethod = Applymethod::OneLineOneEntry then
            GenJnlLine3.SetFilter("Line No.",'<>%1',GenJnlLine."Line No.")
          else
            GenJnlLine3.SetFilter("Line No.",'<>%1',GenJnlLine2."Line No.");
          if VendLedgEntry2."Document Type" <> VendLedgEntry2."document type"::" " then
            if GenJnlLine3.Find('-') then
              GenJnlLine3.FieldError(
                "Applies-to Doc. No.",
                StrSubstNo(
                  Text031,
                  VendLedgEntry2."Document Type",VendLedgEntry2."Document No.",
                  VendLedgEntry2."Vendor No."));
        end;

        DocType := Format(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocDate := VendLedgEntry2."Posting Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CalcFields("Remaining Amount");

        LineAmount :=
          -ABSMin(
            VendLedgEntry2."Remaining Amount" -
            VendLedgEntry2."Remaining Pmt. Disc. Possible" -
            VendLedgEntry2."Accepted Payment Tolerance",
            VendLedgEntry2."Amount to Apply");

        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,LineAmount),
            Currency."Amount Rounding Precision");

        if ((VendLedgEntry2."Document Type" in [VendLedgEntry2."document type"::Invoice,
                                                VendLedgEntry2."document type"::"Credit Memo"]) and
            (VendLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) and
            (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) or
           VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
          LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
          if VendLedgEntry2."Accepted Payment Tolerance" <> 0 then
            LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        end else begin
          if RemainingAmount2 >=
             ROUND(
               -(ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                   VendLedgEntry2."Amount to Apply")),Currency."Amount Rounding Precision")
          then begin
            LineAmount2 :=
              ROUND(
                -(ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                    VendLedgEntry2."Amount to Apply")),Currency."Amount Rounding Precision");
            LineAmount :=
              ROUND(
                ExchangeAmt(VendLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                  LineAmount2),Currency."Amount Rounding Precision");
          end else begin
            LineAmount2 := RemainingAmount2;
            LineAmount :=
              ROUND(
                ExchangeAmt(VendLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                  LineAmount2),Currency."Amount Rounding Precision");
          end;
          LineDiscount := 0;
        end;
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;


    procedure InitializeRequest(BankAcc: Code[20];LastCheckNo: Code[20];NewOneCheckPrVend: Boolean;NewReprintChecks: Boolean;NewTestPrint: Boolean;NewPreprintedStub: Boolean)
    begin
        if BankAcc <> '' then
          if BankAcc2.Get(BankAcc) then begin
            UseCheckNo := LastCheckNo;
            OneCheckPrVendor := NewOneCheckPrVend;
            ReprintChecks := NewReprintChecks;
            TestPrint := NewTestPrint;
            PreprintedStub := NewPreprintedStub;
          end;
    end;


    procedure ExchangeAmt(PostingDate: Date;CurrencyCode: Code[10];CurrencyCode2: Code[10];Amount: Decimal) Amount2: Decimal
    begin
        if (CurrencyCode <> '') and (CurrencyCode2 = '') then
          Amount2 :=
            CurrencyExchangeRate.ExchangeAmtLCYToFCY(
              PostingDate,CurrencyCode,Amount,CurrencyExchangeRate.ExchangeRate(PostingDate,CurrencyCode))
        else
          if (CurrencyCode = '') and (CurrencyCode2 <> '') then
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                PostingDate,CurrencyCode2,Amount,CurrencyExchangeRate.ExchangeRate(PostingDate,CurrencyCode2))
          else
            if (CurrencyCode <> '') and (CurrencyCode2 <> '') and (CurrencyCode <> CurrencyCode2) then
              Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate,CurrencyCode2,CurrencyCode,Amount)
            else
              Amount2 := Amount;
    end;


    procedure ABSMin(Decimal1: Decimal;Decimal2: Decimal): Decimal
    begin
        if Abs(Decimal1) < Abs(Decimal2) then
          exit(Decimal1);
        exit(Decimal2);
    end;


    procedure InputBankAccount()
    begin
        if BankAcc2."No." <> '' then begin
          BankAcc2.Get(BankAcc2."No.");
         // BankAcc2.TESTFIELD("Last Check No.");
          //UseCheckNo := BankAcc2."Last Check No.";
        end;
    end;
}

