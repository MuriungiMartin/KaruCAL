#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5689 "Create FA Depreciation Books"
{
    Caption = 'Create FA Depreciation Books';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Fixed Asset";"Fixed Asset")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code";
            column(ReportForNavId_3794; 3794)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Inactive then
                  CurrReport.Skip;
                if FADeprBook.Get("No.",DeprBookCode) then begin
                  Window.Update(2,"No.");
                  CurrReport.Skip;
                end;
                Window.Update(1,"No.");
                if FANo <> '' then
                  FADeprBook := FADeprBook2
                else
                  FADeprBook.Init;
                FADeprBook."FA No." := "No.";
                FADeprBook."Depreciation Book Code" := DeprBookCode;
                FADeprBook.Insert(true);
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
                    field(DepreciationBook;DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.';

                        trigger OnValidate()
                        begin
                            CheckFADeprBook;
                        end;
                    }
                    field(CopyFromFANo;FANo)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Copy from FA No.';
                        TableRelation = "Fixed Asset";
                        ToolTip = 'Specifies the number of the fixed asset that you want to copy from.';

                        trigger OnValidate()
                        begin
                            CheckFADeprBook;
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
            if DeprBookCode = '' then begin
              FASetup.Get;
              DeprBookCode := FASetup."Default Depr. Book";
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DeprBook.Get(DeprBookCode);
        Window.Open(
          Text000 +
          Text001);
        if FANo <> '' then
          FADeprBook2.Get(FANo,DeprBookCode);
    end;

    var
        Text000: label 'Creating fixed asset book     #1##########\';
        Text001: label 'Not creating fixed asset book #2##########';
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FADeprBook2: Record "FA Depreciation Book";
        Window: Dialog;
        DeprBookCode: Code[10];
        FANo: Code[20];

    local procedure CheckFADeprBook()
    var
        FADeprBook: Record "FA Depreciation Book";
    begin
        if (DeprBookCode <> '') and (FANo <> '') then
          FADeprBook.Get(FANo,DeprBookCode);
    end;
}

