#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 85 "Copy - VAT Posting Setup"
{
    Caption = 'Copy - Tax Posting Setup';
    ProcessingOnly = true;

    dataset
    {
        dataitem("VAT Posting Setup";"VAT Posting Setup")
        {
            DataItemTableView = sorting("VAT Bus. Posting Group","VAT Prod. Posting Group");
            column(ReportForNavId_1756; 1756)
            {
            }

            trigger OnAfterGetRecord()
            begin
                VATPostingSetup.Find;
                if VATSetup then begin
                  "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                  "VAT %" := VATPostingSetup."VAT %";
                  "Unrealized VAT Type" := VATPostingSetup."Unrealized VAT Type";
                  "Adjust for Payment Discount" := VATPostingSetup."Adjust for Payment Discount";
                  "VAT Identifier" := VATPostingSetup."VAT Identifier";
                end;

                if Sales then begin
                  "Sales VAT Account" := VATPostingSetup."Sales VAT Account";
                  "Sales VAT Unreal. Account" := VATPostingSetup."Sales VAT Unreal. Account";
                end;

                if Purch then begin
                  "Purchase VAT Account" := VATPostingSetup."Purchase VAT Account";
                  "Purch. VAT Unreal. Account" := VATPostingSetup."Purch. VAT Unreal. Account";
                  "Reverse Chrg. VAT Acc." := VATPostingSetup."Reverse Chrg. VAT Acc.";
                  "Reverse Chrg. VAT Unreal. Acc." := VATPostingSetup."Reverse Chrg. VAT Unreal. Acc.";
                end;

                if Confirm(Text000,false) then
                  Modify;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("VAT Bus. Posting Group",UseVATPostingSetup."VAT Bus. Posting Group");
                SetRange("VAT Prod. Posting Group",UseVATPostingSetup."VAT Prod. Posting Group");
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
                    field(VATBusPostingGroup;VATPostingSetup."VAT Bus. Posting Group")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tax Bus. Posting Group';
                        TableRelation = "VAT Business Posting Group";
                    }
                    field(VATProdPostingGroup;VATPostingSetup."VAT Prod. Posting Group")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tax Prod. Posting Group';
                        TableRelation = "VAT Product Posting Group";
                    }
                    field(Copy;Selection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Copy';
                        OptionCaption = 'All fields,Selected fields';

                        trigger OnValidate()
                        begin
                            if Selection = Selection::"All fields" then
                              AllfieldsSelectionOnValidate;
                        end;
                    }
                    field(VATetc;VATSetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tax % etc.';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                    field(SalesAccounts;Sales)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sales Accounts';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                    field(PurchaseAccounts;Purch)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase Accounts';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if Selection = Selection::"All fields" then begin
              VATSetup := true;
              Sales := true;
              Purch := true;
            end;
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Copy Tax Posting Setup?';
        UseVATPostingSetup: Record "VAT Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        VATSetup: Boolean;
        Sales: Boolean;
        Purch: Boolean;
        Selection: Option "All fields","Selected fields";


    procedure SetVATSetup(VATPostingSetup2: Record "VAT Posting Setup")
    begin
        UseVATPostingSetup := VATPostingSetup2;
    end;

    local procedure AllfieldsSelectionOnPush()
    begin
        VATSetup := true;
        Sales := true;
        Purch := true;
    end;

    local procedure AllfieldsSelectionOnValidate()
    begin
        AllfieldsSelectionOnPush;
    end;
}

