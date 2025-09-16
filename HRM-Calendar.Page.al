#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68887 "HRM-Calendar"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = UnknownTable61684;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(Year;Year)
                {
                    ApplicationArea = Basic;
                }
                field(Starts;Starts)
                {
                    ApplicationArea = Basic;
                }
                field(Ends;Ends)
                {
                    ApplicationArea = Basic;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
            part(Control1102755000;"HRM-Non Working Days & Dates")
            {
            }
            part(Control1102755001;"Base Calendar Entries Subform")
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Effect Changes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Effect Changes';
                    Image = Save;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        HRCalendarList.SetRange(HRCalendarList.Code,Year);
                        HRCalendarList.SetRange("Non Working",true);
                        if HRCalendarList.Find('-') then
                        repeat
                        HRCalendarList."Non Working":=false;
                        HRCalendarList.Modify;
                        until HRCalendarList.Next=0;




                        HRCalendarList.Reset;
                        Report.Run(39005529,true,true,HRCalendarList);
                        CurrPage.Update;
                    end;
                }
                action("Import Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Calendar';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        //XMLPORT::Calendar;
                        //XMLPORT.RUN(XMLPORT::"HR Calendar");
                    end;
                }
            }
        }
    }

    var
        HRCalendarList: Record UnknownRecord61683;
        Day: Date;
}

