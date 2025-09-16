#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68574 "HMS-Treatment Form Drug"
{
    PageType = ListPart;
    SourceTable = UnknownTable61413;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Product Group";"Product Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Drug Group';
                }
                field("Drug No.";"Drug No.")
                {
                    ApplicationArea = Basic;
                }
                field("Drug Name";"Drug Name")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Of Measure";"Unit Of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Dosage;Dosage)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Issued;Issued)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marked as Incompatible";"Marked as Incompatible")
                {
                    ApplicationArea = Basic;
                }
                field("No stock Drugs";"No stock Drugs")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Prescribe Drugs")
            {
                ApplicationArea = Basic;
                Caption = '&Prescribe Drugs';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Alert Pharmacy About Prescription?')=false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Pharmacy Nos",0D,true);
                    
                    /*Get the treatment from the database*/
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get("Treatment No.") then
                      begin
                        PharmHeader.Reset;
                        PharmHeader.Init;
                          PharmHeader."Pharmacy No." :=NewNo;
                          PharmHeader."Pharmacy Date":=Today;
                          PharmHeader."Pharmacy Time":=Time;
                          PharmHeader."Request Area":=PharmHeader."request area"::Doctor;
                          PharmHeader."Patient No.":=TreatmentHeader."Patient No.";
                          PharmHeader."Student No.":=TreatmentHeader."Student No.";
                          PharmHeader."Employee No.":=TreatmentHeader."Employee No.";
                          PharmHeader."Relative No.":=TreatmentHeader."Relative No.";
                          PharmHeader."Link Type":='Doctor';
                          PharmHeader."Link No.":="Treatment No.";
                        PharmHeader.Insert();
                    
                        TreatmentLine.Reset;
                        TreatmentLine.SetRange(TreatmentLine."Treatment No.","Treatment No.");
                        if TreatmentLine.Find('-') then
                          begin
                            repeat
                              PharmLine.Init;
                                PharmLine."Pharmacy No.":=NewNo;
                                PharmLine."Drug No.":=TreatmentLine."Drug No.";
                                PharmLine.Quantity:=TreatmentLine.Quantity;
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine."Measuring Unit":=TreatmentLine."Unit Of Measure";
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine.Dosage:=TreatmentLine.Dosage;
                                PharmLine.Pharmacy:=TreatmentLine."Pharmacy Code";
                                PharmLine."No Stock Drugs":=TreatmentLine."No stock Drugs";
                              PharmLine.Insert();
                            until TreatmentLine.Next=0;
                          end;
                          Message('The Prescription has been sent to the Pharmacy for Issuance');
                      end;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DrugNoOnFormat;
        DrugNameOnFormat;
        QuantityOnFormat;
        UnitOfMeasureOnFormat;
        DosageOnFormat;
    end;

    var
        HMSSetup: Record UnknownRecord61386;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        TreatmentHeader: Record UnknownRecord61407;
        TreatmentLine: Record UnknownRecord61413;
        PharmHeader: Record UnknownRecord61423;
        PharmLine: Record UnknownRecord61424;

    local procedure DrugNoOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

    local procedure DrugNameOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

    local procedure QuantityOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

    local procedure UnitOfMeasureOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

    local procedure DosageOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;
}

