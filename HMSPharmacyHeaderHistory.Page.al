#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68625 "HMS Pharmacy Header History"
{
    PageType = Document;
    SourceTable = UnknownTable61423;
    SourceTableView = where(Status=const(Completed));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Pharmacy No.";"Pharmacy No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Pharmacy Date";"Pharmacy Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Pharmacy Time";"Pharmacy Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Request Area";"Request Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PatientName;PatientName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bill To Customer No.";"Bill To Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Issued By";"Issued By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000000;"HMS Pharmacy Line History")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        ItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
        HMSSetup: Record UnknownRecord61386;
        PharmHeader: Record UnknownRecord61423;
        PharmLine: Record UnknownRecord61424;
        Patient: Record UnknownRecord61402;


    procedure PostItems()
    begin
        if Confirm('Do you wish to post the record?',false)=false then begin exit end;
        HMSSetup.Reset;
        HMSSetup.Get();
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name",HMSSetup."Pharmacy Item Journal Template");
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name",HMSSetup."Pharmacy Item Journal Batch");
        if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
        LineNo:=1000;
        PharmLine.Reset;
        PharmLine.SetRange(PharmLine."Pharmacy No.","Pharmacy No.");
        if PharmLine.Find('-') then
          begin
            repeat
               ItemJnlLine.Init;
                ItemJnlLine."Line No.":=LineNo;
                ItemJnlLine."Posting Date":=Today;
                ItemJnlLine."Entry Type":=ItemJnlLine."entry type"::"Negative Adjmt.";
                ItemJnlLine."Document No.":=PharmLine."Pharmacy No." + ':' + PharmLine."Drug No.";
                ItemJnlLine."Item No.":=PharmLine."Drug No.";
                ItemJnlLine.Validate(ItemJnlLine."Item No.");
                ItemJnlLine."Location Code":=PharmLine.Pharmacy;
                ItemJnlLine.Validate(ItemJnlLine."Location Code");
                ItemJnlLine.Quantity:=PharmLine."Issued Quantity";
                ItemJnlLine.Validate(ItemJnlLine.Quantity);
                ItemJnlLine."Unit of Measure Code":=PharmLine."Measuring Unit";
                ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                ItemJnlLine."Unit Amount":=PharmLine."Unit Price";
                ItemJnlLine.Validate(ItemJnlLine."Unit Amount");
               ItemJnlLine.Insert();
               PharmLine.Remaining:=PharmLine.Remaining-PharmLine."Issued Units";
               PharmLine.Modify;
               LineNo:=LineNo + 1;
            until PharmLine.Next=0;
            Codeunit.Run(Codeunit::"Item Jnl.-Post Batch",ItemJnlLine);
          end;
    end;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName:='';
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' +Patient."Last Name";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName("Patient No.",PatientName);
    end;
}

