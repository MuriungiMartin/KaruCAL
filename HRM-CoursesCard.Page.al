#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68816 "HRM-Courses Card"
{
    Caption = 'HR Training Courses';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = UnknownTable61238;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Course Code";"Course Code")
                {
                    ApplicationArea = Basic;
                }
                field("Course Tittle";"Course Tittle")
                {
                    ApplicationArea = Basic;
                }
                field("Course Version";"Course Version")
                {
                    ApplicationArea = Basic;
                }
                field("Course Version Description";"Course Version Description")
                {
                    ApplicationArea = Basic;
                }
                field(Directorate;Directorate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Directorate';
                }
                field("Directorate Name";"Directorate Name")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Station Code";"Station Code")
                {
                    ApplicationArea = Basic;
                }
                field("Station Name";"Station Name")
                {
                    ApplicationArea = Basic;
                }
                field("Need Source";"Need Source")
                {
                    ApplicationArea = Basic;
                }
                field("Nature of Training";"Nature of Training")
                {
                    ApplicationArea = Basic;
                }
                field("Training Type";"Training Type")
                {
                    ApplicationArea = Basic;
                }
                field("No of Participants Required";"No of Participants Required")
                {
                    ApplicationArea = Basic;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Duration Units";"Duration Units")
                {
                    ApplicationArea = Basic;
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Quarter Offered";"Quarter Offered")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Of Training";"Cost Of Training")
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field(Provider;Provider)
                {
                    ApplicationArea = Basic;
                }
                field("Provider Name";"Provider Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Closing Status";"Closing Status")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Mark as Closed/Open")
                {
                    ApplicationArea = Basic;
                    Caption = '&Mark as Closed/Open';
                    Image = CloseDocument;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Closed then
                        begin
                            Closed:=false;
                            Message('Training need :: %1 :: has been Re-Opened',"Course Tittle");
                        end
                        else begin
                            Closed:=true;
                            Message('Training need :: %1 :: has been closed',"Course Tittle");
                            Modify;
                        end;
                    end;
                }
            }
        }
    }

    var
        D: Date;
}

