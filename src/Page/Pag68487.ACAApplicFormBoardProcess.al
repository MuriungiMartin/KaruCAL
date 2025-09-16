#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68487 "ACA-Applic. Form Board Process"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=filter(<>Approved));

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
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Year';
                }
                field("Admitted Degree";"Admitted Degree")
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme';
                }
                field("Admitted To Stage";"Admitted To Stage")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stage';
                }
                field("Admitted Semester";"Admitted Semester")
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                }
                field("Date Of Meeting";"Date Of Meeting")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Recommendation";"Admission Board Recommendation")
                {
                    ApplicationArea = Basic;
                }
                field("Deferred Until";"Deferred Until")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action("Academic Background Subjects")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Background Subjects';
                    Image = History;
                    RunObject = Page "ACA-Application Form Academic";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Professional Qualifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Professional Qualifications';
                    Image = ProfileCalender;
                    RunObject = Page "ACA-Application Form Qualif.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Employment History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment History';
                    Image = Employee;
                    RunObject = Page "ACA-Application Form Employ.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Academic Referees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Referees';
                    Image = CustomerContact;
                    RunObject = Page "ACA-Application Form Acad. Ref";
                    RunPageLink = "Application No."=field("Application No.");
                }
            }
        }
        area(processing)
        {
            action("&View Details")
            {
                ApplicationArea = Basic;
                Caption = '&View Details';
                Image = Line;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "ACA-Applic. Form Board";
                RunPageLink = "Application No."=field("Application No.");
            }
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Mark as Ratified")
                {
                    ApplicationArea = Basic;
                    Caption = '&Mark as Ratified';
                    Image = Approve;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /*Set the range for the records to be used*/
                        Apps.Reset;
                        //Apps.SETRANGE(Apps.Status,Apps.Status::"Admission Board");
                        Apps.SetRange(Apps.Select,true);
                        Apps.SetFilter(Apps.Status,'<>%1',Apps.Status::Approved);
                        /*Check if there are any records*/
                        if Apps.Count<1 then
                          begin
                            Error ('No Application records selected for the selected operation');
                          end;
                        if Apps.Find('-') then
                          begin
                            repeat
                              /*Check if the record has all the required details*/
                              if Apps."Admitted Degree"='' then
                                begin
                                  Error('An Application is being ratified without the Degree Course to be admitted to being selected.Process Aborted');
                                end;
                              if "Date Of Meeting"=0D then
                                begin
                                  Error ('The Admissions Board Date Of Meeting has to be inserted.Process aborting');
                                end;
                              Apps.Status:=Apps.Status::Approved;
                              Apps.Validate(Apps.Status);
                              Apps."Admission Board Date":=Today;
                              Apps."Admission Board Time":=Time;
                              "Admit/NotAdmit":='Admit';
                              Apps.Modify;
                            until Apps.Next=0;
                          end;
                        Message ('The Selected Application request have been marked as Ratified');

                    end;
                }
                action("&Mark as Not Ratified")
                {
                    ApplicationArea = Basic;
                    Caption = '&Mark as Not Ratified';
                    Image = Reject;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /*Set the range for the records to be used*/
                        Apps.Reset;
                        Apps.SetRange(Apps.Status,Apps.Status::"Admission Board");
                        Apps.SetRange(Apps.Select,true);
                        /*Check if there are any records*/
                        if Apps.Count<1 then
                          begin
                            Error ('No Application records selected for the selected operation');
                          end;
                        if Apps.Find('-') then
                          begin
                            repeat
                              Apps.Status:=Apps.Status::"Admission Board Rejected";
                              Apps."Admission Board Date":=Today;
                              Apps."Admission Board Time":=Time;
                              Apps.Modify;
                            until Apps.Next=0;
                          end;
                        Message ('The Selected Application request have been marked as Not Ratified');

                    end;
                }
            }
        }
    }

    var
        Apps: Record UnknownRecord61358;
}

