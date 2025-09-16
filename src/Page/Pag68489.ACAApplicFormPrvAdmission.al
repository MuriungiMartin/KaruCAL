#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68489 "ACA-Applic. Form Prv Admission"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=const(Approved));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admitted Degree";"Admitted Degree")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admitted To Stage";"Admitted To Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Semester";"Admitted Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Meeting";"Date Of Meeting")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Deferred Until";"Deferred Until")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Country of Origin";"Country of Origin")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Process Provisional Admission Letters")
                {
                    ApplicationArea = Basic;
                    Caption = '&Process Provisional Admission Letters';

                    trigger OnAction()
                    begin
                        /*Process the provisional admission letter*/
                        Apps.Reset;
                        Apps.SetRange(Apps.Status,Apps.Status::Approved);
                        Apps.SetRange(Apps.Select,true);
                        /*Check if any records are within the range*/
                        if Apps.Count<1 then
                          begin
                            Error('No Applications Selected For Processing');
                          end
                        else
                          begin
                            /*Ask for user confirmation*/
                           if Confirm('Process Provisional Admission Letters For ' + Format(Apps.Count) + ' Applications?',false)=false then begin exit
                        end;
                          end;
                        
                        /*Loop thru the records processing each*/
                        if Apps.Find('-') then
                          begin
                            repeat
                              Apps.Status:=Apps.Status::"Provisional Admission";
                              Apps.Modify;
                            until Apps.Next=0;
                          end;
                        
                        /*Alert the user that the process is complete*/
                        Message('Select Applications have been Processed and Ready for Provisional Admission Letter Printing');

                    end;
                }
                action("Process & Print Provisional Admission Letters")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process & Print Provisional Admission Letters';
                    Image = Print;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /*Process the provisional admission letter*/
                        Apps.Reset;
                        Apps.SetRange(Apps.Status,Apps.Status::Approved);
                        Apps.SetRange(Apps.Select,true);
                        /*Check if any records are within the range*/
                        if Apps.Count<1 then
                          begin
                            Error('No Applications Selected For Processing');
                          end
                        else
                          begin
                            /*Ask for user confirmation*/
                            if Confirm('Process Provisional Admission Letters For ' + Format(Apps.Count) + 'Applications?',false)=false then begin exit
                        end;
                          end;
                        
                        SendToPrinter:=true;
                        /*Ask for confirmation to send to default printer*/
                        if Confirm('Send Directly to Printer?',false)=false then
                          begin
                            SendToPrinter:=false;
                          end;
                        
                        /*Loop thru the records processing each*/
                        if Apps.Find('-') then
                          begin
                            repeat
                              Report.Run(39005755,false,SendToPrinter,Apps);
                              Apps.Status:=Apps.Status::"Provisional Admission";
                              Apps.Modify;
                            until Apps.Next=0;
                          end;
                        
                        /*Alert the user that the process is complete*/
                        Message('Select Applications have been Processed and Ready for Provisional Admission Letter Printing');

                    end;
                }
            }
        }
    }

    var
        Apps: Record UnknownRecord61358;
        SendToPrinter: Boolean;
}

