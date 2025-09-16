#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5945 CreateCreditfromContractLines
{
    SingleInstance = true;
    TableNo = "Service Contract Line";

    trigger OnRun()
    begin
        ServContractHeader.Get("Contract Type","Contract No.");
        if not Credited and
           not "New Line"
        then begin
          if "Line Amount" > 0 then
            if ServContractHeader."Automatic Credit Memos" then
              if "Credit Memo Date" > 0D then
                CreditNoteNo := ServContractMgt.CreateContractLineCreditMemo(Rec,true);
          ServItemLine.Reset;
          ServItemLine.SetCurrentkey("Contract No.");
          ServItemLine.SetRange("Contract No.","Contract No.");
          ServItemLine.SetRange("Contract Line No.","Line No.");
          ServItemLineExist := ServItemLine.FindFirst;
        end;

        if LinesToDelete = 1 then begin
          LinesToDelete := 0;
          if CreditNoteNo <> '' then
            Message(Text000,CreditNoteNo);
          if ServItemLineExist then begin
            if LinesToDelete = 1 then begin
              Message(Text002,Lowercase(TableCaption));
            end else
              Message(Text001);
          end;
          ServItemLineExist := false;
          CreditNoteNo := '';
        end;
    end;

    var
        ServContractHeader: Record "Service Contract Header";
        ServItemLine: Record "Service Item Line";
        ServContractMgt: Codeunit ServContractManagement;
        CreditNoteNo: Code[20];
        Text000: label 'Credit Memo %1 was created.';
        ServItemLineExist: Boolean;
        LinesToDelete: Integer;
        Text001: label 'Some service contract lines are part of a service order/s.\You have to update this service order/s manually.';
        Text002: label 'This %1 is part of a service order/s.\You have to update this service order/s manually.';


    procedure SetSelectionFilterNo(LinesSelected: Integer)
    begin
        LinesToDelete := LinesSelected;
    end;


    procedure InitVariables()
    begin
        ServItemLineExist := false;
        CreditNoteNo := '';
        LinesToDelete := 0;
    end;
}

