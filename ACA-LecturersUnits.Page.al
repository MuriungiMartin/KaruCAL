#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68766 "ACA-Lecturers Units"
{
    PageType = Document;
    SourceTable = UnknownTable61188;
    SourceTableView = where(Lecturer=filter(Yes));

    layout
    {
        area(content)
        {
            group(Genera)
            {
                Caption = 'Genera';
                Editable = true;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee No.';
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("PIN Number";"PIN Number")
                {
                    ApplicationArea = Basic;
                }
                field("Cellular Phone Number";"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("Part Time";"Part Time")
                {
                    ApplicationArea = Basic;
                }
                field("Section Code";"Section Code")
                {
                    ApplicationArea = Basic;
                }
                field("Company E-Mail";"Company E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Portal Password";"Portal Password")
                {
                    ApplicationArea = Basic;
                }
                field("Password Changed?";"Changed Password")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Units/Subjects")
            {
                Caption = 'Units/Subjects';
                part("Lecturer Units";"ACA-Lecturers Units/Subjects")
                {
                    SubPageLink = Lecturer=field("No.");
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Lecturer)
            {
                Caption = 'Lecturer';
                action("Units Lecture can take")
                {
                    ApplicationArea = Basic;
                    Caption = 'Units Lecture can take';
                    RunObject = Page "ACA-Units Lecture can take";
                    RunPageLink = Lecturer=field("No.");
                }
                separator(Action1102755004)
                {
                }
                action("Lecturer Appointment Letter")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecturer Appointment Letter';

                    trigger OnAction()
                    begin
                         LecUnits.Reset;
                         LecUnits.SetFilter(LecUnits.Lecturer,"No.");
                         if LecUnits.Find('-') then
                         Report.Run(39005734,true,true,LecUnits);
                    end;
                }
                separator(Action1000000010)
                {
                }
                action("Create Payable Account")
                {
                    ApplicationArea = Basic;
                    Image = Accounts;

                    trigger OnAction()
                    begin
                          if not Vend.Get("No.")  then begin
                          Vend.Init;
                          Vend."No.":="No.";
                          Vend.Name:="First Name"+' '+"Middle Name"+' '+"Last Name";
                          Vend."Search Name":= "First Name"+' '+"Middle Name"+' '+"Last Name";
                          Vend."Vendor Posting Group":= 'Lecturer';
                          Vend."Gen. Bus. Posting Group":= 'Local';
                          Vend."VAT Bus. Posting Group":= 'Local';
                          Vend.Insert;
                          Message('Vendor Account No '+"No."+' has been created successfully');
                          end else begin
                          Error('Vendor Account No '+"No."+' already exists');
                          end;
                    end;
                }
                separator(Action1000000006)
                {
                }
                separator(Action1000000004)
                {
                }
                action("Post Lecturer Invoice")
                {
                    ApplicationArea = Basic;
                    Image = Invoice;

                    trigger OnAction()
                    begin

                            if Confirm('Do you really want to post the lecturer invoice',false) =true then begin
                            GeneralSetup.Get;
                            LecUnits.Reset;
                            LecUnits.SetRange(LecUnits.Lecturer,"No.");
                            LecUnits.SetRange(LecUnits.Posted,false);
                            LecUnits.SetRange(LecUnits."Claim to pay",true);
                            if LecUnits.Find('-') then begin
                            repeat
                            if LecUnits."Claimed Amount">0 then begin
                            gnLine.Init;
                            gnLine."Journal Template Name":='General';
                            gnLine."Journal Batch Name":='Lecturer';
                            gnLine."Line No.":=gnLine."Line No."+100;
                            gnLine."Account Type":=gnLine."account type"::Vendor;
                            gnLine."Account No.":="No.";
                            gnLine."Posting Date":=Today;
                            gnLine."Document No.":="No."+'/'+LecUnits.Unit;
                            gnLine.Description:= CopyStr(LecUnits.Semester+'/'+LecUnits.Unit+'/'+LecUnits.Description,1,50);
                            gnLine."Bal. Account Type":=gnLine."bal. account type"::"G/L Account";
                            gnLine."Bal. Account No.":= '70310';//GeneralSetup."Lecturers Expense Account";
                            gnLine.Amount:=LecUnits."Claimed Amount"*-1;
                            gnLine."PartTime Claim":= true;
                            gnLine.Validate("PartTime Claim");
                            gnLine.Insert;
                            end;
                            until LecUnits.Next=0;
                            end;
                            gnLine.Reset;
                            gnLine.SetRange(gnLine."Journal Template Name",'General');
                            gnLine.SetRange(gnLine."Journal Batch Name",'Lecturer');
                            if gnLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post",gnLine);
                            end;
                            LecUnits.Reset;
                            LecUnits.SetRange(LecUnits.Lecturer,"No.");
                            LecUnits.SetRange(LecUnits.Posted,false);
                            LecUnits.SetRange(LecUnits."Claim to pay",true);
                            if LecUnits.Find('-') then begin
                            repeat
                            LecUnits.Posted:=true;
                            LecUnits."Posted By":=UserId;
                            LecUnits."Posted On":=Today;
                            LecUnits.Modify;
                            until LecUnits.Next=0;
                            end;
                            Message('Invoice posted successfully');
                            end;
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Lecturer:=true;
         if "No." = '' then begin
          if HumanResSetup.Get then;
          HumanResSetup.TestField("PT. No.");
          "No.":=NoSeriesMgt.GetNextNo(HumanResSetup."PT. No.",Today,true);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
           Lecturer:=true;
        
           if "No." = '' then begin
          if HumanResSetup.Get then;
          HumanResSetup.TestField("PT. No.");
          "No.":=NoSeriesMgt.GetNextNo(HumanResSetup."PT. No.",Today,true);
        end;
        /*
        IF "No." <> xRec."No." THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Employee Nos.");
          NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
          "No. Series" := '';
        END;*/

    end;

    var
        KPAObjectives: Record UnknownRecord61293;
        KPACode: Code[20];
        LecUnits: Record UnknownRecord65202;
        Vend: Record Vendor;
        gnLine: Record "Gen. Journal Line";
        GeneralSetup: Record UnknownRecord61534;
        GL: Record "G/L Entry";
        HumanResSetup: Record UnknownRecord61204;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

