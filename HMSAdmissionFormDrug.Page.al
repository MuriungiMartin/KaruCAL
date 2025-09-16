#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68640 "HMS Admission Form Drug"
{
    PageType = ListPart;
    SourceTable = UnknownTable61439;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Pharmacy Code";"Pharmacy Code")
                {
                    ApplicationArea = Basic;
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
                field("Marked as Incompatible";"Marked as Incompatible")
                {
                    ApplicationArea = Basic;
                }
                field(Issued;Issued)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Actual Quantity Issued";"Actual Quantity Issued")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Quantity";"Remaining Quantity")
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
                    AdmissionHeader.Reset;
                    if AdmissionHeader.Get("Admission No.") then
                      begin
                        PharmHeader.Reset;
                        PharmHeader.Init;
                          PharmHeader."Pharmacy No." :=NewNo;
                          PharmHeader."Pharmacy Date":=Today;
                          PharmHeader."Pharmacy Time":=Time;
                          PharmHeader."Request Area":=PharmHeader."request area"::Doctor;
                          PharmHeader."Patient No.":=AdmissionHeader."Patient No.";
                          PharmHeader."Student No.":=AdmissionHeader."Student No.";
                          PharmHeader."Employee No.":=AdmissionHeader."Employee No.";
                          PharmHeader."Relative No.":=AdmissionHeader."Relative No.";
                          PharmHeader."Link Type":='Admission';
                          PharmHeader."Link No.":="Admission No.";
                        PharmHeader.Insert();
                    
                        AdmissionLine.Reset;
                        AdmissionLine.SetRange(AdmissionLine."Admission No.","Admission No.");
                        if AdmissionLine.Find('-') then
                          begin
                            repeat
                              PharmLine.Init;
                                PharmLine."Pharmacy No.":=NewNo;
                                PharmLine."Drug No.":=AdmissionLine."Drug No.";
                                PharmLine.Quantity:=AdmissionLine.Quantity;
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine."Measuring Unit":=AdmissionLine."Unit Of Measure";
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine.Dosage:=AdmissionLine.Dosage;
                                PharmLine.Pharmacy:=AdmissionLine."Pharmacy Code";
                              PharmLine.Insert();
                            until AdmissionLine.Next=0;
                          end;
                          Message('The Prescription has been sent to the Pharmacy for Issuance');
                      end;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PharmacyCodeOnFormat;
        DrugNoOnFormat;
        DrugNameOnFormat;
        QuantityOnFormat;
        UnitOfMeasureOnFormat;
        DosageOnFormat;
        RemarksOnFormat;
        ActualQuantityIssuedOnFormat;
        RemainingQuantityOnFormat;
    end;

    var
        HMSSetup: Record UnknownRecord61386;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        AdmissionHeader: Record UnknownRecord61426;
        AdmissionLine: Record UnknownRecord61439;
        PharmHeader: Record UnknownRecord61423;
        PharmLine: Record UnknownRecord61424;

    local procedure PharmacyCodeOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

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

    local procedure RemarksOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

    local procedure ActualQuantityIssuedOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;

    local procedure RemainingQuantityOnFormat()
    begin
        if "Marked as Incompatible"=true then;
    end;
}

