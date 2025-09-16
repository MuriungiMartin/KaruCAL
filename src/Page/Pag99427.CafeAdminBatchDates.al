#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99427 "Cafe Admin Batch Dates"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Company Information";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(StartDates;StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                }
                field(EdnDates;EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ViewBatches)
            {
                ApplicationArea = Basic;
                Caption = 'View Batches';
                Image = ViewPage;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(DateFilter);
                    //IF ((StartDate = 0D) AND (EndDate <> 0D)) THEN DateFilter := '..'+FORMAT(EndDate);
                    //IF ((StartDate <> 0D) AND (EndDate = 0D)) THEN DateFilter :=FORMAT(StartDate)+ '..';
                    if ((StartDate <> 0D) and (EndDate <> 0D)) then DateFilter :=Format(StartDate)+ '..'+Format(EndDate);
                    if DateFilter = '' then Error('Specify Start and End Date!');
                    if StartDate > EndDate then Error('Invalid start date!');

                    Clear(CafeteriaSalesBatches);
                    CafeteriaSalesBatches.Reset;
                    CafeteriaSalesBatches.SetFilter(CafeteriaSalesBatches.Batch_Date,DateFilter);
                    if CafeteriaSalesBatches.Find('-') then begin
                    //  CafeteriaSalesBatches.SETFILTER("Un-posted Receipts",'>%1',0);
                     // IF CafeteriaSalesBatches.FIND('-') THEN BEGIN
                            Page.Run(99432,CafeteriaSalesBatches);
                      //  END ELSE ERROR('No unposted receipt batches!');
                      end else Error('No batches in the filter!');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        StartDate := Today;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text[150];
        CafeteriaSalesBatches: Record "Cafeteria Sales Batches";
}

