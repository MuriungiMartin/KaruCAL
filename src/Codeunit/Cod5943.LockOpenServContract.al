#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5943 "Lock-OpenServContract"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'It is not possible to lock this %1 Service %2 because some lines have zero %3.';
        Text001: label 'It is not possible to open a %1 service contract';
        Text002: label 'New lines have been added to this contract.\Would you like to continue?';
        SignServContractDoc: Codeunit SignServContractDoc;
        Text003: label 'You cannot lock service contract with negative annual amount.';
        Text004: label 'You cannot lock service contract with zero annual amount when invoice period is different from None.';


    procedure LockServContract(FromServContractHeader: Record "Service Contract Header")
    var
        ServContractHeader: Record "Service Contract Header";
        ServContractLine: Record "Service Contract Line";
    begin
        ServContractHeader := FromServContractHeader;
        with ServContractHeader do begin
          if "Change Status" = "change status"::Locked then
            exit;
          CalcFields("Calcd. Annual Amount");
          TestField("Annual Amount","Calcd. Annual Amount");
          if "Annual Amount" < 0 then
            Error(Text003);
          if "Invoice Period" <> "invoice period"::None then
            if "Annual Amount" = 0 then
              Error(Text004);

          LockTable;
          if ("Contract Type" = "contract type"::Contract) and
             (Status = Status::Signed)
          then begin
            ServContractLine.Reset;
            ServContractLine.SetRange("Contract Type","Contract Type");
            ServContractLine.SetRange("Contract No.","Contract No.");
            ServContractLine.SetRange("Line Amount",0);
            if not ServContractLine.IsEmpty then
              Error(Text000,Status,"Contract Type",ServContractLine.FieldCaption("Line Amount"));
            ServContractLine.Reset;
            ServContractLine.SetRange("Contract Type","Contract Type");
            ServContractLine.SetRange("Contract No.","Contract No.");
            ServContractLine.SetRange("New Line",true);
            if not ServContractLine.IsEmpty then begin
              if  not Confirm(Text002) then
                exit;
              SignServContractDoc.AddendumToContract(ServContractHeader);
            end;
          end;
          Get(FromServContractHeader."Contract Type",FromServContractHeader."Contract No.");
          "Change Status" := "change status"::Locked;
          Modify;
        end;
    end;


    procedure OpenServContract(ServContractHeader: Record "Service Contract Header")
    begin
        with ServContractHeader do begin
          if "Change Status" = "change status"::Open then
            exit;
          LockTable;
          if (Status = Status::Canceled) and ("Contract Type" = "contract type"::Contract)then
            Error(Text001,Status);
          "Change Status" := "change status"::Open;
          Modify;
        end;
    end;
}

