#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90020 "FIN-Medical Claims Journal"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable90023;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Category";"Claim Category")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Posting Time";"Posting Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Staff Name";"Staff Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(GetStaffsForAllocations)
            {
                ApplicationArea = Basic;
                Caption = 'Get Employees';
                Description = 'Get staff list for allocations';
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Get staff list for allocations';

                trigger OnAction()
                begin
                    if Confirm('Get employees for Annual Medical ceiling update?',true)=false then Error('Cancelled by user!');
                    Clear(FINMedicalClaimsJournal);
                    FINMedicalClaimsJournal.SetRange("Batch User ID",UserId);
                    if FINMedicalClaimsJournal.Find('-') then FINMedicalClaimsJournal.DeleteAll;
                    Clear(FINMedicalClaimPeriods);
                    FINMedicalClaimPeriods.Reset;
                    FINMedicalClaimPeriods.SetFilter("Period Start Date",'<%1|=%2',Today);
                    FINMedicalClaimPeriods.SetFilter("Period End Date",'>%1|=%2',Today);
                    if not (FINMedicalClaimPeriods.Find('-')) then Error('No current Period specified on the claims period setup');
                    Clear(HRMEmployeeD);
                    Clear(Counts);
                    HRMEmployeeD.Reset;
                    HRMEmployeeD.SetRange(Status,HRMEmployeeD.Status::Normal);
                    HRMEmployeeD.SetFilter("Salary Grade",'<>%1','');
                    if HRMEmployeeD.Find('-') then begin
                      repeat
                          begin
                          Clear(vend);
                          vend.Reset;
                          vend.SetRange("No.",'MED'+HRMEmployeeD."No.");
                          if not (vend.Find('-')) then begin
                            // Missing Staff in Vendors.. Create
                            vend.Init;
                            vend."No.":='MED'+HRMEmployeeD."No.";
                            vend.Name:=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                            vend."Search Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                            vend."Gen. Bus. Posting Group":='LOCAL';
                            vend."Vendor Posting Group":='STAFFMEDIC';
                            vend."Staff No.":= HRMEmployeeD."No.";
                            vend."Medical Claim Account":= true;
                            if vend.Insert(true) then begin

                            end;
                            end else begin
                            vend.Name:=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                            vend."Search Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                            if vend.Modify(true) then;
                            end;


                            Clear(HRMJob_Salarygradesteps);
                            HRMJob_Salarygradesteps.Reset;
                            HRMJob_Salarygradesteps.SetRange("Salary Grade code",HRMEmployeeD."Salary Grade");
                            HRMJob_Salarygradesteps.SetRange("Employee Category",HRMEmployeeD."Salary Category");
                            if HRMJob_Salarygradesteps.Find('-') then begin
                              Counts+=1;
                              if HRMJob_Salarygradesteps."In-Patient Medical Ceilling" <>0 then begin
                                  FINMedicalClaimsJournal.Init;
                                  FINMedicalClaimsJournal."Entry No.":=Counts;
                                  FINMedicalClaimsJournal."Document No.":='MCA'+Format(FINMedicalClaimPeriods."Period Code");
                                  FINMedicalClaimsJournal."Staff No.":='MED'+HRMEmployeeD."No.";
                                  FINMedicalClaimsJournal."Staff Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                                  FINMedicalClaimsJournal."Transaction Type":=FINMedicalClaimsJournal."transaction type"::Allocation;
                                  FINMedicalClaimsJournal.Amount:=HRMJob_Salarygradesteps."In-Patient Medical Ceilling";
                                  FINMedicalClaimsJournal."Claim Category":=FINMedicalClaimsJournal."claim category"::"In-patient";
                                  FINMedicalClaimsJournal."Batch User ID":=UserId;
                                  if FINMedicalClaimsJournal.Insert(true) then;
                                end;
                                Counts+=1;
                              if HRMJob_Salarygradesteps."Out-Patient Medical Ceilling" <>0 then begin
                                  FINMedicalClaimsJournal.Init;
                                  FINMedicalClaimsJournal."Entry No.":=Counts;
                                  FINMedicalClaimsJournal."Document No.":='MCA'+Format(FINMedicalClaimPeriods."Period Code");
                                  FINMedicalClaimsJournal."Staff No.":='MED'+HRMEmployeeD."No.";
                                  FINMedicalClaimsJournal."Staff Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                                  FINMedicalClaimsJournal."Transaction Type":=FINMedicalClaimsJournal."transaction type"::Allocation;
                                  FINMedicalClaimsJournal.Amount:=HRMJob_Salarygradesteps."Out-Patient Medical Ceilling";
                                  FINMedicalClaimsJournal."Claim Category":=FINMedicalClaimsJournal."claim category"::"Out-Patient";
                                  FINMedicalClaimsJournal."Batch User ID":=UserId;
                                  if FINMedicalClaimsJournal.Insert(true) then;
                                end;

                                Counts+=1;
                              if HRMJob_Salarygradesteps."Optical/Dental Ceiling" <>0 then begin
                                  FINMedicalClaimsJournal.Init;
                                  FINMedicalClaimsJournal."Entry No.":=Counts;
                                  FINMedicalClaimsJournal."Document No.":='MCA'+Format(FINMedicalClaimPeriods."Period Code");
                                  FINMedicalClaimsJournal."Staff No.":='MED'+HRMEmployeeD."No.";
                                  FINMedicalClaimsJournal."Staff Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                                  FINMedicalClaimsJournal."Transaction Type":=FINMedicalClaimsJournal."transaction type"::Allocation;
                                  FINMedicalClaimsJournal.Amount:=HRMJob_Salarygradesteps."Optical/Dental Ceiling";
                                  FINMedicalClaimsJournal."Claim Category":=FINMedicalClaimsJournal."claim category"::"Optical/Dental";
                                  FINMedicalClaimsJournal."Batch User ID":=UserId;
                                  if FINMedicalClaimsJournal.Insert(true) then;
                                end;
                              end;
                          end;
                        until HRMEmployeeD.Next=0;
                      end;
                      CurrPage.Update;
                      Message('Done!');
                end;
            }
            action(PostJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    entries: Integer;
                begin
                    Clear(UserSetup);
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if not (UserSetup.Find('-')) then Error('Access denied!');
                    Clear(FINMedicalClaimPeriods);
                    FINMedicalClaimPeriods.Reset;
                    FINMedicalClaimPeriods.SetFilter("Period Start Date",'<%1|=%2',Today);
                    FINMedicalClaimPeriods.SetFilter("Period End Date",'>%1|=%2',Today);
                    if not (FINMedicalClaimPeriods.Find('-')) then Error('No current Period specified on the claims period setup');
                    UserSetup.TestField("Can Update Claims");
                    Clear(entries);
                    Clear(FINMedicalClaimsLedger);
                    FINMedicalClaimsLedger.Reset;
                    if FINMedicalClaimsLedger.FindLast then entries:=FINMedicalClaimsLedger."Entry No.";
                    if Confirm('Post Journal?',true) = false then Error('Posting Cancelled!');
                    Clear(FINMedicalClaimsJournal);
                    FINMedicalClaimsJournal.SetRange("Batch User ID",UserId);
                    if FINMedicalClaimsJournal.Find('-') then begin
                      repeat
                        begin
                        entries+=1;
                      FINMedicalClaimsLedger.Init;
                      FINMedicalClaimsLedger."Entry No.":=entries;
                    FINMedicalClaimsLedger."Staff No.":=FINMedicalClaimsJournal."Staff No.";
                    FINMedicalClaimsLedger."Transaction Type":=FINMedicalClaimsJournal."Transaction Type";
                    if ((FINMedicalClaimsJournal."Transaction Type"=FINMedicalClaimsJournal."transaction type"::"+Ve Adjustment") or
                    (FINMedicalClaimsJournal."Transaction Type"=FINMedicalClaimsJournal."transaction type"::Allocation)) then
                    FINMedicalClaimsLedger.Amount:=FINMedicalClaimsJournal.Amount
                    else if ((FINMedicalClaimsJournal."Transaction Type"=FINMedicalClaimsJournal."transaction type"::Consumption) or
                    (FINMedicalClaimsJournal."Transaction Type"=FINMedicalClaimsJournal."transaction type"::"-Ve Adjustment")) then
                    FINMedicalClaimsLedger.Amount:=FINMedicalClaimsJournal.Amount*(-1)
                    else FINMedicalClaimsLedger.Amount:=0;
                    FINMedicalClaimsLedger."Document No.":=FINMedicalClaimsJournal."Document No.";
                    FINMedicalClaimsLedger."Claim Category":=FINMedicalClaimsJournal."Claim Category";
                    FINMedicalClaimsLedger."Transaction Date":=Today;
                    FINMedicalClaimsLedger."Period Code":=FINMedicalClaimPeriods."Period Code";
                      if ((FINMedicalClaimsJournal."Staff No."<>'') and (FINMedicalClaimsJournal.Amount<>0)) then
                      FINMedicalClaimsLedger.Insert(true);
                      FINMedicalClaimsJournal.Delete(true);
                      end;
                        until FINMedicalClaimsJournal.Next = 0;
                      end else Error('Nothing to post!');
                      Message('Done!');
                end;
            }
            action(Imp)
            {
                ApplicationArea = Basic;
                Caption = 'Import from Excel';
                Image = ImportCodes;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Import form excel?',true)=false then Error('Cancelled by user!');
                    if Confirm('Arrange your columns in the following order:\'+
                      '- Entry No. e.g.. 1\'+
                      '- Document No. e.g. PV0155\'+
                      '- Staff No: e.g., 0158\'+
                      '- Amount e.g. 150,000\'+
                      '- Transaction Type: e.g. Allocation\'+
                      '- Claim Category, e.g., In-Patient',true) = false then;
                      if Confirm('Select the file...',true) = false then;
                      Xmlport.Run(50212,false,true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("Batch User ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Batch User ID",UserId);
    end;

    var
        HRMEmployeeD: Record UnknownRecord61118;
        HRMJob_Salarygradesteps: Record UnknownRecord61790;
        FINMedicalClaimsJournal: Record UnknownRecord90023;
        FINMedicalClaimPeriods: Record UnknownRecord90021;
        Counts: Integer;
        FINMedicalClaimsLedger: Record UnknownRecord90022;
        UserSetup: Record "User Setup";
        vend: Record Vendor;
}

