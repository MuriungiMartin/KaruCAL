#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69280 "ACA-Copy Fee Structure"
{
    PageType = Card;
    SourceTable = UnknownTable61511;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Caption = 'Program Code';
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Program Description';
                    Editable = false;
                }
                field(FromCode;FromCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy From Code';
                    TableRelation = "ACA-Programme".Code;

                    trigger OnValidate()
                    begin
                        if progs.Get(FromCode) then begin
                          FromDesc:=progs.Description;
                          end;
                    end;
                }
                field(FromDesc;FromDesc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Fro Description';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(CopyFeeStruct)
            {
                ApplicationArea = Basic;
                Caption = 'Copy Fee Structure';
                Image = CopyBOM;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Code=FromCode then Error('The Source and destination Programs cannot be the same.');
                    // Check & Insert The Stages on the New Programs
                    progStages.Reset;
                    progStages.SetRange("Programme Code",FromCode);
                    if progStages.Find('-') then begin
                    repeat
                      begin
                          progStages2.Reset;
                      progStages2.SetRange("Programme Code",Code);
                      progStages2.SetRange(Code,progStages.Code);
                      if not progStages2.Find('-') then begin
                        progStages2.Init;
                        progStages2."Programme Code":=Rec.Code;
                    progStages2.Code:=progStages.Code;
                    progStages2.Description:=progStages.Description;
                    progStages2."G/L Account":=progStages."G/L Account";
                    progStages2.Department:=progStages.Department;
                    progStages2.Remarks:=progStages.Remarks;
                    progStages2."Final Stage":=progStages."Final Stage";
                        progStages2.Insert;
                      end;
                      end;
                    until progStages.Next=0;
                    end;
                    ////////////////////////////////////
                    FeeByStage.Reset;
                    FeeByStage.SetRange(FeeByStage."Programme Code",FromCode);
                    if FeeByStage.Find('-') then  begin
                      FeeByStage2.Reset;
                      FeeByStage2.SetRange(FeeByStage2."Programme Code",Code);
                      if FeeByStage2.Find('-') then begin
                        FeeByStage2.DeleteAll;
                        end;
                      // Fees found.
                      repeat
                          begin
                          FeeByStage2.Init;
                    FeeByStage2."Programme Code":=Code;
                    FeeByStage2."Stage Code":=FeeByStage."Stage Code";
                    FeeByStage2.Semester:=FeeByStage.Semester;
                    FeeByStage2."Student Type":=FeeByStage."Student Type";
                    FeeByStage2."Settlemet Type":=FeeByStage."Settlemet Type";
                    FeeByStage2."Seq.":=FeeByStage."Seq.";
                    FeeByStage2."Break Down":=FeeByStage."Break Down";
                    FeeByStage2.Remarks:=FeeByStage.Remarks;
                    FeeByStage2."Amount Not Distributed":=FeeByStage."Amount Not Distributed";
                    FeeByStage2."programme Name":=FeeByStage."programme Name";
                    FeeByStage2."Stage Description":=FeeByStage."Stage Description";
                    FeeByStage2."Stage Charges":=FeeByStage."Stage Charges";
                          FeeByStage2.Insert;
                          end;
                        until FeeByStage.Next=0;
                    end else Error('The Specified Source Program does not have a fee Structure.');

                    Chargeables.Reset;
                    Chargeables.SetRange(Chargeables."Programme Code",FromCode);
                    if Chargeables.Find('-') then begin
                      Chargeables2.Reset;
                        Chargeables2.SetRange(Chargeables2."Programme Code",Code);
                        if Chargeables2.Find('-') then begin
                          Chargeables2.DeleteAll;
                          end;
                      // Copy Chargeable Items
                      repeat
                        begin
                          Chargeables2.Init;
                          Chargeables2."Programme Code":=Code;
                    Chargeables2."Stage Code":=Chargeables."Stage Code";
                    Chargeables2.Code:=Chargeables.Code;
                    Chargeables2."Settlement Type":=Chargeables."Settlement Type";
                    Chargeables2.Semester:=Chargeables.Semester;
                    Chargeables2.Description:=Chargeables.Description;
                    Chargeables2.Amount:=Chargeables.Amount;
                    Chargeables2.Remarks:=Chargeables.Remarks;
                    Chargeables2."Recovered First":=Chargeables."Recovered First";
                    Chargeables2."Student Type":=Chargeables."Student Type";
                    Chargeables2."Recovery Priority":=Chargeables."Recovery Priority";
                    Chargeables2."Distribution (%)":=Chargeables."Distribution (%)";
                    Chargeables2."Distribution Account":=Chargeables."Distribution Account";
                    //Chargeables2."Programme Description":=Chargeables."Programme Description";
                          Chargeables2.Insert;
                        end;
                        until Chargeables.Next=0;
                      end else Error('The Chargeable items for the specified source does not exist.');

                    CurrPage.Close;
                    Message('Fee Structure Copied Successfully');
                end;
            }
        }
    }

    var
        FromCode: Code[20];
        FromDesc: Text[150];
        FeeByStage: Record UnknownRecord61523;
        Chargeables: Record UnknownRecord61533;
        FeeByStage2: Record UnknownRecord61523;
        Chargeables2: Record UnknownRecord61533;
        progStages: Record UnknownRecord61516;
        progStages2: Record UnknownRecord61516;
        progs: Record UnknownRecord61511;
}

