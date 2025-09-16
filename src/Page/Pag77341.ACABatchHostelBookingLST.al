#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77341 "ACA-Batch Hostel Booking LST"
{
    CardPageID = "ACA-Batch Hostel Booking CD";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ACA-Batch Room Alloc. Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Hostel Block";"Hostel Block")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Time Created";"Time Created")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Allocation";"Number of Allocation")
                {
                    ApplicationArea = Basic;
                }
                field("Total Allocations in Year";"Total Allocations in Year")
                {
                    ApplicationArea = Basic;
                }
                field("Notification type";"Notification type")
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
            action(PostAlloc)
            {
                ApplicationArea = Basic;
                Caption = 'Post Allocation';
                Image = PostedVendorBill;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ACABatchRoomAllocDetails: Record "ACA-Batch Room Alloc. Details";
                begin
                    if Confirm('This will post allocation and bill the students if the student exists,\Continue?',true) = false then Error('Cancelled!');

                    Clear(GenJournalBatch);
                    GenJournalBatch.Reset;
                    GenJournalBatch.SetRange("Journal Template Name",'SALES');
                    GenJournalBatch.SetRange(Name,'ACCOM');
                    if not GenJournalBatch.Find('-') then begin
                      GenJournalBatch.Init;
                      GenJournalBatch."Journal Template Name" := 'SALES';
                      GenJournalBatch.Name := 'ACCOM';
                      GenJournalBatch.Insert;
                      end;

                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'ACCOM');
                    GenJnl.DeleteAll;

                        Clear(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails.Reset;
                    ACABatchRoomAllocDetails.SetRange("posted to Hostels?",false);
                    ACABatchRoomAllocDetails.SetRange("Hostel Block",Rec."Hostel Block");
                    ACABatchRoomAllocDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACABatchRoomAllocDetails.SetRange("Exists in Student List",true);
                    ACABatchRoomAllocDetails.SetFilter(Credits,'>%1',6499.99);
                      if Confirm('Post selected allocations only?', true) = true then begin
                    ACABatchRoomAllocDetails.SetRange(Selected,true);
                        end;
                    if ACABatchRoomAllocDetails.Find('-') then begin
                    // Post allocations if record exists
                    repeat
                    begin
                    ACABatchRoomAllocDetails.AllocateStudentHostel(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails."posted to Hostels?" := true;
                    ACABatchRoomAllocDetails."Posted By" := UserId;
                    ACABatchRoomAllocDetails."Posted Date" := Today;
                    ACABatchRoomAllocDetails."Posted Time" := Time;
                    ACABatchRoomAllocDetails.Modify;
                    end;
                    until ACABatchRoomAllocDetails.Next = 0;
                    end else Error('Nothing to post');
                        Message('Rooms Allocated Successfully');


                    //Post New
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'ACCOM');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
                    end;

                    //Post New
                end;
            }
            action(ImportAlloc)
            {
                ApplicationArea = Basic;
                Caption = 'Import Allocations';
                Image = ImportChartOfAccounts;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Import Allocations?',true) = false then Error('Importation cancelled!');
                    if Confirm('Arrange your CSV file in the following order:\Academic Year\'+
                      'Student No\Gender\Block Code\Room Code\Space Code\............................................\'+
                      'Note:\The file must be a CSV with only one sheet',true)=false then;
                      Xmlport.Run(77382,false,true);
                end;
            }
            action(PrintReport)
            {
                ApplicationArea = Basic;
                Caption = 'Print Report';
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin

                    Clear(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails.Reset;
                    ACABatchRoomAllocDetails.SetRange("Hostel Block",Rec."Hostel Block");
                    if ACABatchRoomAllocDetails.Find('-') then begin
                      Report.Run(77340,true,false,ACABatchRoomAllocDetails);
                    end;
                end;
            }
            action(ClearDetails)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Details';
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Clear Records?',false)=false then Error('Cancelled!');
                    Clear(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails.Reset;
                    ACABatchRoomAllocDetails.SetRange("Hostel Block",Rec."Hostel Block");
                    if ACABatchRoomAllocDetails.Find('-') then ACABatchRoomAllocDetails.DeleteAll;
                    Message('Records cleared!');
                end;
            }
            action(SendNotifications)
            {
                ApplicationArea = Basic;
                Caption = 'Send Notifications';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Rec."Notification type" = Rec."notification type"::" " then Error('Notifications are not enabled for this batch.');
                    if Confirm('Send email allocation notification?',true)= false  then  Error('Mail/SMS sending cancelled');
                    Clear(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails.Reset;
                    ACABatchRoomAllocDetails.SetRange("Hostel Block",Rec."Hostel Block");
                    ACABatchRoomAllocDetails.SetRange("Notification Send",false);
                    if ACABatchRoomAllocDetails.Find('-') then begin
                      repeat
                        begin
                        if ((Rec."Notification type" = Rec."notification type"::"E-Mail") or (Rec."Notification type" = Rec."notification type"::Both)) then
                        SendMailNoticiations.SendEmailEasy('Dear '+ACABatchRoomAllocDetails."Student Name",'This is to notify you that you have been allocated',
                        'accomodation at the university.',
                        'You have been allocated in a room in  '+ACABatchRoomAllocDetails."Hostel Block"+', Room no: '+ACABatchRoomAllocDetails."Room No"+', Space: '+
                        ACABatchRoomAllocDetails."Room Space"+'. Kindly collect the keys and other items from the Hostel manager',
                        'Disclaimer: This notification is for information purposes.','',
                        ACABatchRoomAllocDetails."Email Address",'HOSTEL ALLOCATION BLOCK: '+ACABatchRoomAllocDetails."Hostel Block"+
                        ', Room no: '+ACABatchRoomAllocDetails."Room No"+', Space: ');

                    //Hostel Allocation Notification:  BLOCK: RUNDA A, Room no: RUND A 0028, Space:  . // Send SMS
                    if ((ACABatchRoomAllocDetails."Phone Number" <> '') and
                     ( ((Rec."Notification type" = Rec."notification type"::Phone) or (Rec."Notification type" = Rec."notification type"::Both)))) then begin
                    SendMailNoticiations.Send_SMS_Easy(ACABatchRoomAllocDetails."Phone Number",
                    'Hostel Allocation Notification: '+ACABatchRoomAllocDetails."Hostel Block"+
                        ', Room: '+ACABatchRoomAllocDetails."Hostel Block"+', Space:'+ACABatchRoomAllocDetails."Room Space",
                      'Kindly visit the Hostel Manager for allocation and issuance of keys and bring along a  filled room agreement form','');
                      end;
                      ACABatchRoomAllocDetails."Notification Send" := true;
                      ACABatchRoomAllocDetails.Modify;
                        end;
                        until ACABatchRoomAllocDetails.Next = 0;
                      Message('Notifications have been send.');
                    end;
                end;
            }
            action("Posted Allocations")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Allocations';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "PosteBatch Hostel Alloc. Dets.";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              "Hostel Block"=field("Hostel Block");
            }
            action(ArchiveAllocations)
            {
                ApplicationArea = Basic;
                Caption = 'Archive Allocations';
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                begin
                    if Confirm('Delete allocations?',true)= false  then  Error('Deletion cancelled');
                    Clear(UserSetup);
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if UserSetup.Find('-') then;
                    UserSetup.TestField("Can Archive Prof. Host. Allocs");

                    Clear(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails.Reset;
                    ACABatchRoomAllocDetails.SetRange("Hostel Block",Rec."Hostel Block");
                    if ACABatchRoomAllocDetails.Find('-') then begin
                      repeat
                        begin
                      ACABatchRoomAllocDetails.Delete(true);
                        end;
                        until ACABatchRoomAllocDetails.Next = 0;
                    end;
                end;
            }
            action(ArchAllocs)
            {
                ApplicationArea = Basic;
                Caption = 'Archive';
                Image = AlternativeAddress;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Archived Hostel Alloc. Dets.";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              "Hostel Block"=field("Hostel Block");
            }
            action(PostImpAlloc)
            {
                ApplicationArea = Basic;
                Caption = 'Post Imported';
                Image = AddWatch;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin

                    if Confirm('This will post allocation and bill the students if the student exists,\Continue?',true) = false then Error('Cancelled!');

                    Clear(GenJournalBatch);
                    GenJournalBatch.Reset;
                    GenJournalBatch.SetRange("Journal Template Name",'SALES');
                    GenJournalBatch.SetRange(Name,'ACCOM');
                    if not GenJournalBatch.Find('-') then begin
                      GenJournalBatch.Init;
                      GenJournalBatch."Journal Template Name" := 'SALES';
                      GenJournalBatch.Name := 'ACCOM';
                      GenJournalBatch.Insert;
                      end;

                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'ACCOM');
                    GenJnl.DeleteAll;

                        Clear(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails.Reset;
                    ACABatchRoomAllocDetails.SetRange("posted to Hostels?",true);
                    ACABatchRoomAllocDetails.SetRange("Hostel Block",Rec."Hostel Block");
                    ACABatchRoomAllocDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACABatchRoomAllocDetails.SetRange("Exists in Student List",true);
                    ACABatchRoomAllocDetails.SetFilter("Temp. Allocation Billed",'%1',false);
                      if Confirm('Post selected allocations only?', true) = true then begin
                    ACABatchRoomAllocDetails.SetRange(Selected,true);
                        end;
                    if ACABatchRoomAllocDetails.Find('-') then begin
                    // Post allocations if record exists
                    repeat
                    begin
                    ACABatchRoomAllocDetails.AllocateStudentHostelTemp(ACABatchRoomAllocDetails);
                    ACABatchRoomAllocDetails."posted to Hostels?" := true;
                    ACABatchRoomAllocDetails."Posted By" := UserId;
                    ACABatchRoomAllocDetails."Posted Date" := Today;
                    ACABatchRoomAllocDetails."Posted Time" := Time;
                    ACABatchRoomAllocDetails."Temp. Allocation Billed" := true;
                    ACABatchRoomAllocDetails.Modify;
                    end;
                    until ACABatchRoomAllocDetails.Next = 0;
                    end else Error('Nothing to post');


                    //Post New
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'ACCOM');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",GenJnl);
                    end;
                        Message('Rooms Allocated Successfully');

                    //Post New
                end;
            }
        }
    }

    var
        ACABatchRoomAllocDetails: Record "ACA-Batch Room Alloc. Details";
        SendMailNoticiations: Codeunit webportals;
        GenJnl: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
}

