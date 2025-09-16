#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68572 "HMS-Treatment Form Radiology"
{
    PageType = ListPart;
    SourceTable = UnknownTable61411;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Radiology Type Code";"Radiology Type Code")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Type Name";"Radiology Type Name")
                {
                    ApplicationArea = Basic;
                }
                field("Date Due";"Date Due")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Remarks";"Radiology Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
            action("&Request Tests")
            {
                ApplicationArea = Basic;
                Caption = '&Request Tests';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Send Radiology Request?',false)=false then begin exit end;
                    
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Radiology Nos",0D,true);
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get("Treatment No.") then
                      begin
                        RadiologyHeader.Reset;
                        RadiologyHeader.Init;
                          RadiologyHeader."Radiology No.":=NewNo;
                          RadiologyHeader."Radiology Date":=Today;
                          RadiologyHeader."Radiology Time":=Time;
                          RadiologyHeader."Radiology Area":=RadiologyHeader."radiology area"::Doctor;
                          RadiologyHeader."Patient No.":=TreatmentHeader."Patient No.";
                          RadiologyHeader."Student No.":=TreatmentHeader."Student No.";
                          RadiologyHeader."Employee No.":=TreatmentHeader."Employee No.";
                          RadiologyHeader."Relative No.":=TreatmentHeader."Relative No.";
                          RadiologyHeader."Link No.":=TreatmentHeader."Treatment No.";
                          RadiologyHeader."Link Type":='Doctor'  ;
                        RadiologyHeader.Insert();
                    
                        /*Insert the lines*/
                        TreatmentLine.Reset;
                        TreatmentLine.SetRange(TreatmentLine."Treatment No.","Treatment No.");
                        if TreatmentLine.Find('-') then
                          begin
                            repeat
                              RadiologyLine.Reset;
                              RadiologyLine.Init;
                                RadiologyLine."Radiology no.":=NewNo;
                                RadiologyLine."Radiology Type Code":=TreatmentLine."Radiology Type Code";
                              RadiologyLine.Insert();
                            until TreatmentLine.Next=0;
                          end;
                      end;
                      Report.Run(39005796,true,true,TreatmentHeader);
                    Message('Radiology Test Request Forwarded');

                end;
            }
        }
    }

    var
        TreatmentHeader: Record UnknownRecord61407;
        TreatmentLine: Record UnknownRecord61411;
        RadiologyHeader: Record UnknownRecord61419;
        RadiologyLine: Record UnknownRecord61420;
        NewNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HMSSetup: Record UnknownRecord61386;
}

