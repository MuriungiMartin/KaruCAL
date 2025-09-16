#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 8621 "Config. Package - Process"
{
    Caption = 'Config. Package - Process';
    ProcessingOnly = true;
    TransactionType = UpdateNoLocks;

    dataset
    {
        dataitem("Config. Package Table";"Config. Package Table")
        {
            DataItemTableView = sorting("Package Code","Table ID") order(ascending);
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Message(StrSubstNo(ImplementProcessingLogicMsg,"Table ID"));

                // Code sample of the text transformation on package data
                // ProcessCustomRulesExample("Config. Package Table");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        SourceTable = "Config. Package Table";

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

    var
        ImplementProcessingLogicMsg: label 'Implement processing logic for Table %1 in Report 8621 - Config. Package - Process.', Comment='%1 - a table Id.';

    local procedure ApplyTextTransformation(ConfigPackageTable: Record "Config. Package Table";FieldNo: Integer;TransformationRule: Record "Transformation Rule")
    var
        ConfigPackageData: Record "Config. Package Data";
    begin
        if GetConfigPackageData(ConfigPackageData,ConfigPackageTable,FieldNo) then
          repeat
            ConfigPackageData.Value := CopyStr(TransformationRule.TransformText(ConfigPackageData.Value),1,250);
            ConfigPackageData.Modify;
          until ConfigPackageData.Next = 0;
    end;

    local procedure GetConfigPackageData(var ConfigPackageData: Record "Config. Package Data";ConfigPackageTable: Record "Config. Package Table";FieldId: Integer): Boolean
    begin
        ConfigPackageData.SetRange("Package Code",ConfigPackageTable."Package Code");
        ConfigPackageData.SetRange("Table ID",ConfigPackageTable."Table ID");
        ConfigPackageData.SetRange("Field ID",FieldId);
        exit(ConfigPackageData.FindSet(true,false));
    end;


    procedure ProcessCustomRulesExample(ConfigPackageTable: Record "Config. Package Table")
    var
        Customer: Record Customer;
        BankAccount: Record "Bank Account";
        PaymentTerms: Record "Payment Terms";
        TransformationRule: Record "Transformation Rule";
    begin
        case ConfigPackageTable."Table ID" of
          Database::"Payment Terms":
            begin
              TransformationRule."Transformation Type" := TransformationRule."transformation type"::"Title Case";
              ApplyTextTransformation(ConfigPackageTable,PaymentTerms.FieldNo(Description),TransformationRule);
            end;
          Database::"Bank Account":
            begin
              TransformationRule."Transformation Type" :=
                TransformationRule."transformation type"::"Remove Non-Alphanumeric Characters";
              ApplyTextTransformation(ConfigPackageTable,BankAccount.FieldNo("SWIFT Code"),TransformationRule);
              ApplyTextTransformation(ConfigPackageTable,BankAccount.FieldNo(Iban),TransformationRule);
            end;
          Database::Customer:
            begin
              TransformationRule."Transformation Type" := TransformationRule."transformation type"::Replace;
              TransformationRule."Find Value" := 'Mister';
              TransformationRule."Replace Value" := 'Mr.';
              ApplyTextTransformation(ConfigPackageTable,Customer.FieldNo(Name),TransformationRule);
            end;
        end;
    end;
}

