#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68222 "HRM-Emp. Leave Journal Lines"
{
    PageType = List;
    SourceTable = UnknownTable61618;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Name";"Staff Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Description";"Transaction Description")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Days";"No. of Days")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(GetAnnual_Leave)
            {
                ApplicationArea = Basic;
                Caption = 'Get Annual Leave Allocations';
                Image = GetLines;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                     if Confirm('Generate annual Leave allocations?',true)=false then exit;
                     Clear(ints);
                      hremployee.Reset;
                     hremployee.SetRange(hremployee.Status,hremployee.Status::Active);
                     if hremployee.Find('-') then begin
                      // Populate leave journal with
                       leaveJournal.Reset;
                    if leaveJournal.Find('-') then
                    leaveJournal.DeleteAll;
                      repeat
                        begin
                      if (hremployee.Grade<>'') then begin
                      salaryGrades.Reset;
                      //salaryGrades.SETRANGE(salaryGrades."Employee Category",hremployee."Salary Category");
                      salaryGrades.SetRange(salaryGrades.Grade,hremployee.Grade);
                      if salaryGrades.Find('-') then begin
                      if salaryGrades."Annual Leave Days"<>0 then begin

                    // populate the Journal
                    leaveledger.Reset;
                    leaveledger.SetRange(leaveledger."Document No",hremployee."No.");
                    leaveledger.SetRange(leaveledger."Leave Period",Date2dmy(Today,3));
                    leaveledger.SetFilter(leaveledger."Entry Type",'<>%1',leaveledger."entry type"::Allocation);
                    if not leaveledger.Find('-') then begin
                    // Insert the Journals
                    // Delete Existing Journal Entries first

                    ints:=ints+1;
                    leaveJournal.Init;
                    leaveJournal."Line No.":=ints;
                    leaveJournal."Staff No.":=hremployee."No.";
                    leaveJournal."Staff Name":=hremployee."First Name"+' '+hremployee."Middle Name"+' '+hremployee."Last Name";
                    leaveJournal."Transaction Description":='Leave Allocations for '+Format(Date2dmy(Today,3));
                    leaveJournal."Leave Type":='ANNUAL';
                    leaveJournal."No. of Days":=salaryGrades."Annual Leave Days";
                    leaveJournal."Transaction Type":=leaveJournal."transaction type"::Allocation;
                    leaveJournal."Document No.":='ALL-'+Format(Date2dmy(Today,3));
                    leaveJournal."Posting Date":=Today;
                    leaveJournal."Leave Period":=Date2dmy(Today,3);
                    leaveJournal.Insert;
                    end;

                      end;
                      end;
                      end;
                        end;
                      until hremployee.Next=0;
                     end;
                       Message('Annual leave days generated successfully!');
                end;
            }
            action(Post_Leave)
            {
                ApplicationArea = Basic;
                Caption = 'Post Leave Journal';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                         Codeunit.Run(60198);
                end;
            }
            action(GetAnnual_LeaveII)
            {
                ApplicationArea = Basic;
                Caption = 'Adjust Unutilized Days';
                Image = GetLines;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                     if Confirm('Generate annual unutilized leave adjustments?',true)=false then exit;
                     Clear(ints);
                     leaveJournal.Reset;
                    if leaveJournal.Find('-') then
                    leaveJournal.DeleteAll;
                      hremployee.Reset;
                     hremployee.SetRange(hremployee.Status,hremployee.Status::Active);
                     if hremployee.Find('-') then begin
                      // Populate leave journal with
                      repeat
                        begin
                      if (hremployee.Grade<>'') then begin
                           hremployee.CalcFields("Leave Balance");
                      salaryGrades.Reset;
                      //salaryGrades.SETRANGE(salaryGrades."Employee Category",hremployee."Salary Category");
                      salaryGrades.SetRange(salaryGrades.Grade,hremployee.Grade);
                      if salaryGrades.Find('-') then begin
                        if hremployee."Leave Balance">(salaryGrades."Annual Leave Days"/2) then begin
                      if salaryGrades."Annual Leave Days"<>0 then begin

                    // populate the Journal
                    // Insert the Journals
                    // Delete Existing Journal Entries first

                    ints:=ints+1;
                    leaveJournal.Init;
                    leaveJournal."Line No.":=ints;
                    leaveJournal."Staff No.":=hremployee."No.";
                    leaveJournal."Staff Name":=hremployee."First Name"+' '+hremployee."Middle Name"+' '+hremployee."Last Name";
                    leaveJournal."Transaction Description":='Unutilized Leave Adjustments for '+Format(Date2dmy(Today,3));
                    leaveJournal."Leave Type":='ANNUAL';
                    leaveJournal."No. of Days":=(hremployee."Leave Balance"-(salaryGrades."Annual Leave Days"/2));
                    leaveJournal."Transaction Type":=leaveJournal."transaction type"::"Negative Adjustment";
                    leaveJournal."Document No.":='ADJ-'+Format(Date2dmy(Today,3));
                    leaveJournal."Posting Date":=Today;
                    leaveJournal."Leave Period":=Date2dmy(Today,3);
                    leaveJournal.Insert;
                    end;
                      end;
                      end;
                      end;
                        end;
                      until hremployee.Next=0;
                     end;
                       Message('Annual leave days generated successfully!');
                end;
            }
            group(Import)
            {
                Caption = '&Actions';
                action("Import Leave Balances")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Leave Balances';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                         if Confirm('!!!!!!!!!!!!!!!!!!!!....................... IMPORTANT.................!!!!!!!!!!!!!!!!!!!!!!!\'+
                         'Please ensure that your data is saved in ''.CSV'' format i.e. Comma delimeted.'+
                         '\The data should be in the following format:\'+
                         ' Line No|Staff No|Name|Description|Leave Type|No. of Days|Trans Type|Doc. No|Post Date|Leave Period.\'+
                         '\'+
                         '...........................EXAMPLE.........................\'+
                         '1|0001|Wanjala Tom|2015Leave days|ANNUAL|23|ALLOCATION|leave_2015|22012015|2015\'+
                         '2|0002|Jacinta Mwali|2015Leave days|ANNUAL|23|ALLOCATION|leave_2015|22012015|2015\'+
                         '\'+
                         'Continue?',true)=false then Error('Cancelled by user!');
                          Xmlport.Run(50166,false,true);
                         Message('Imported Successfully!');
                    end;
                }
            }
        }
    }

    var
        salaryGrades: Record UnknownRecord61301;
        hremployee: Record UnknownRecord61188;
        leaveledger: Record UnknownRecord61659;
        leaveJournal: Record UnknownRecord61618;
        ints: Integer;
}

