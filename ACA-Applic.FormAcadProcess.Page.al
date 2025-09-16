#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68484 "ACA-Applic. Form Acad Process"
{
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=filter("Dean Approved"|"Dean Rejected"));

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
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Second Degree Choice";"Second Degree Choice")
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
                field("Admissable Status";"Admissable Status")
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
                    RunObject = Page "ACA-Application Form Academic";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Professional Qualifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Professional Qualifications';
                    RunObject = Page "ACA-Application Form Qualif.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Employment History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment History';
                    RunObject = Page "ACA-Application Form Employ.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Academic Referees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Referees';
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
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "ACA-Application Card";
                RunPageLink = "Application No."=field("Application No.");
            }
            action("&Process Applications")
            {
                ApplicationArea = Basic;
                Caption = '&Process Applications';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Set the range for the records*/
                    Apps.Reset;
                    Apps.SetFilter(Apps.Status,'Dean Approved|Dean Rejected');
                    Apps.SetRange(Apps.Select,true);
                    if Apps.Find('-') then
                      begin
                        /*Check if any records have been selected*/
                        if Apps.Count=0 then
                          begin
                            Error ('No Application Forms selected for Processing');
                          end;
                      end
                    else
                      begin
                        Error ('No Application Forms selected for Processing');
                      end;
                    if Confirm('A Total of ' +Format(Apps.Count) + ' are about to be Processed.Continue?',true)=false then begin exit end;
                      /*Get the new code*/
                      AppSetup.Reset;
                      AppSetup.Get();
                      NewCode:=NoSeriesMgt.GetNextNo(AppSetup."Summary Application Nos.",0D,true);
                    
                      /*Loop thru the records updating the status to Academic Division*/
                      repeat
                        Apps."Batch No.":=NewCode;
                        Apps."Batch Date":=Today;
                        Apps."Batch Time":=Time;
                        Apps.Status:=Apps.Status::"Admission Board";
                        Apps."Admissable Status":='ADMISSABLE';
                        Apps.Modify;
                      until Apps.Next=0;
                      AppBatch.Reset;
                      AppBatch.Init;
                        AppBatch."Batch No.":=NewCode;
                        AppBatch."Batch Date":=Today;
                        AppBatch."Batch Time":=Time;
                      AppBatch.Insert;
                      /*Alert the user that the applications have been moved to a particular batch*/
                      Message('The Selected Applications have been moved to the Batch ' +Format(NewCode));

                end;
            }
        }
    }

    var
        Apps: Record UnknownRecord61358;
        AppBatch: Record UnknownRecord61368;
        IntC: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewCode: Code[20];
        AppSetup: Record UnknownRecord61367;
}

