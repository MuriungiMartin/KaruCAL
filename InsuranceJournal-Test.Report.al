#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5622 "Insurance Journal - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insurance Journal - Test.rdlc';
    Caption = 'Insurance Journal - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Insurance Journal Batch";"Insurance Journal Batch")
        {
            DataItemTableView = sorting("Journal Template Name",Name);
            RequestFilterFields = "Journal Template Name",Name;
            column(ReportForNavId_6073; 6073)
            {
            }
            column(Insurance_Journal_Batch_Journal_Template_Name;"Journal Template Name")
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                PrintOnlyIfDetail = true;
                column(ReportForNavId_5444; 5444)
                {
                }
                column(Insurance_Journal_Batch__Name;"Insurance Journal Batch".Name)
                {
                }
                column(Insurance_Journal_Batch___Journal_Template_Name_;"Insurance Journal Batch"."Journal Template Name")
                {
                }
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(Insurance_Journal_Line__TABLECAPTION__________InsuranceJnlLineFilter;"Insurance Journal Line".TableCaption + ': ' + InsuranceJnlLineFilter)
                {
                }
                column(InsuranceJnlLineFilter;InsuranceJnlLineFilter)
                {
                }
                column(Insurance_Journal_Batch__NameCaption;Insurance_Journal_Batch__NameCaptionLbl)
                {
                }
                column(Insurance_Journal_Batch___Journal_Template_Name_Caption;"Insurance Journal Batch".FieldCaption("Journal Template Name"))
                {
                }
                column(Insurance_Journal___TestCaption;Insurance_Journal___TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Insurance_Journal_Line__Posting_Date_Caption;Insurance_Journal_Line__Posting_Date_CaptionLbl)
                {
                }
                column(Insurance_Journal_Line__Document_Type_Caption;"Insurance Journal Line".FieldCaption("Document Type"))
                {
                }
                column(Insurance_Journal_Line__Document_No__Caption;"Insurance Journal Line".FieldCaption("Document No."))
                {
                }
                column(Insurance_Journal_Line__FA_No__Caption;"Insurance Journal Line".FieldCaption("FA No."))
                {
                }
                column(Insurance_Journal_Line_DescriptionCaption;"Insurance Journal Line".FieldCaption(Description))
                {
                }
                column(Insurance_Journal_Line_AmountCaption;"Insurance Journal Line".FieldCaption(Amount))
                {
                }
                column(Insurance_Journal_Line__Insurance_No__Caption;"Insurance Journal Line".FieldCaption("Insurance No."))
                {
                }
                dataitem("Insurance Journal Line";"Insurance Journal Line")
                {
                    DataItemLink = "Journal Template Name"=field("Journal Template Name"),"Journal Batch Name"=field(Name);
                    DataItemLinkReference = "Insurance Journal Batch";
                    DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.");
                    RequestFilterFields = "Posting Date";
                    column(ReportForNavId_3747; 3747)
                    {
                    }
                    column(Insurance_Journal_Line__Posting_Date_;Format("Posting Date"))
                    {
                    }
                    column(Insurance_Journal_Line__Document_Type_;"Document Type")
                    {
                    }
                    column(Insurance_Journal_Line__Document_No__;"Document No.")
                    {
                    }
                    column(Insurance_Journal_Line__FA_No__;"FA No.")
                    {
                    }
                    column(Insurance_Journal_Line_Description;Description)
                    {
                    }
                    column(Insurance_Journal_Line_Amount;Amount)
                    {
                    }
                    column(Insurance_Journal_Line__Insurance_No__;"Insurance No.")
                    {
                    }
                    column(Insurance_Journal_Line_Line_No_;"Line No.")
                    {
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
                        column(Warning_Caption;Warning_CaptionLbl)
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
                        if "Insurance No." <> '' then begin
                          if "Posting Date" = 0D then
                            AddError(
                              StrSubstNo(
                                Text000,
                                FieldCaption("Posting Date")));
                          if "FA No." = '' then
                            AddError(
                              StrSubstNo(
                                Text000,
                                FieldCaption("FA No.")))
                          else
                            if not FA.Get("FA No.") then
                              AddError(
                                StrSubstNo(
                                  Text001,FA.TableCaption,FA.FieldCaption("No.")));
                          if "Document No." = '' then
                            AddError(StrSubstNo(Text000,FieldCaption("Document No.")));
                        end;

                        if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                          AddError(DimMgt.GetDimCombErr);

                        TableID[1] := Database::Insurance;
                        No[1] := "Insurance No.";
                        if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
                          AddError(DimMgt.GetDimValuePostingErr);
                    end;

                    trigger OnPreDataItem()
                    begin
                        InsuranceJnlTempl.Get("Insurance Journal Batch"."Journal Template Name");

                        CurrReport.CreateTotals(Amount);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.PageNo := 1;
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

    trigger OnPreReport()
    begin
        InsuranceJnlLineFilter := "Insurance Journal Line".GetFilters;
        FASetup.Get;
        FASetup.TestField("Automatic Insurance Posting",true);
    end;

    var
        Text000: label '%1 must be specified.';
        Text001: label '%1 %2 does not exist.';
        InsuranceJnlTempl: Record "Insurance Journal Template";
        FA: Record "Fixed Asset";
        FASetup: Record "FA Setup";
        DimMgt: Codeunit DimensionManagement;
        ErrorCounter: Integer;
        ErrorText: array [50] of Text[250];
        InsuranceJnlLineFilter: Text;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        Insurance_Journal_Batch__NameCaptionLbl: label 'Journal Batch';
        Insurance_Journal___TestCaptionLbl: label 'Insurance Journal - Test';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Insurance_Journal_Line__Posting_Date_CaptionLbl: label 'Posting Date';
        Warning_CaptionLbl: label 'Warning!';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;
}

