#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68571 "HMS-Treatment Form Laboratory"
{
    PageType = ListPart;
    SourceTable = UnknownTable61410;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Laboratory Test Package Code";"Laboratory Test Package Code")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Test Package Name";"Laboratory Test Package Name")
                {
                    ApplicationArea = Basic;
                }
                field("Date Due";"Date Due")
                {
                    ApplicationArea = Basic;
                }
                field(Results;Results)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
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
                    /*Send the request now?*/
                    
                    
                    if Confirm('Send Laboratory Test Request Now?',false)=true then
                      begin
                        HMSSetup.Reset;
                        HMSSetup.Get();
                        NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Lab Test Request Nos",0D,true);
                        TreatmentHeader.Reset;
                        TreatmentHeader.Get("Treatment No.");
                        LabHeader.Reset;
                        LabHeader.Init;
                          LabHeader."Laboratory No.":=NewNo;
                          LabHeader."Laboratory Date":=Today;
                          LabHeader."Laboratory Time":=Time;
                          LabHeader."Patient No.":=TreatmentHeader."Patient No.";
                          LabHeader."Student No.":=TreatmentHeader."Student No.";
                          LabHeader."Employee No.":=TreatmentHeader."Employee No.";
                          LabHeader."Relative No.":=TreatmentHeader."Relative No.";
                          LabHeader."Request Area":=LabHeader."request area"::Doctor;
                          LabHeader."Link Type":='Treatment';
                          LabHeader."Link No.":=TreatmentHeader."Treatment No.";
                       labheader2.Reset;
                       labheader2.SetRange(labheader2."Link No.",TreatmentHeader."Treatment No.");
                       if labheader2.Find('-') then
                         begin
                           if Confirm('Record already exist,Confirm Continue?') then   LabHeader.Insert;
                         end
                       else
                         begin
                          LabHeader.Insert;
                         end;
                    DocLabRequestLines.Reset;
                    DocLabRequestLines.SetRange(DocLabRequestLines."Treatment No.","Treatment No.");
                    DocLabRequestLines.SetRange(DocLabRequestLines.Status,DocLabRequestLines.Status::New);
                    if DocLabRequestLines.Find('-') then begin
                      repeat
                      DocLabRequestLines.Status:=DocLabRequestLines.Status::Forwarded;
                      DocLabRequestLines.Modify;
                        /*
                         LabSpecimenSetup.RESET;
                         LabSpecimenSetup.SETRANGE(LabSpecimenSetup.Test,DocLabRequestLines."Laboratory Test Package Code");
                            IF LabSpecimenSetup.FIND('-') THEN BEGIN
                             REPEAT
                             */
                              LabTestLines.Init;
                               LabTestLines."Laboratory No.":=LabHeader."Laboratory No.";
                               //LabTestLines."Laboratory Test Code":=LabSpecimenSetup.Test;
                               LabTestLines."Laboratory Test Code":=DocLabRequestLines."Laboratory Test Package Code";
                               LabTestLines."Specimen Code":=LabSpecimenSetup.Specimen;
                               LabTestLines."Measuring Unit Code":=LabSpecimenSetup."Measuring Unit";
                               //LabTestLines."Laboratory Test Name":=LabSpecimenSetup."Test Name";
                               LabTestLines."Laboratory Test Name":=DocLabRequestLines."Laboratory Test Package Name";
                    
                               LabTestLines."Specimen Name":=LabSpecimenSetup."Specimen Name";
                               LabTestLines.Insert;
                          //  UNTIL LabSpecimenSetup.NEXT=0;
                          // END;
                    
                          /* DocLabRequestLines.reset;
                           DocLabRequestLines.SETRANGE(DocLabRequestLines."Laboratory Test Package Code",LabTestLines."Laboratory Test Code");
                    
                           DocLabRequestLines.find('-') then begin
                             REPEAT
                               LabTestLines.INIT;
                              // LabTestLines."Laboratory No.":=LabHeader."Laboratory No.";
                               LabTestLines."Laboratory Test Code":=LabSpecimenSetup.Test;
                               LabTestLines."Specimen Code":=LabSpecimenSetup.Specimen;
                               LabTestLines."Measuring Unit Code":=LabSpecimenSetup."Measuring Unit";
                               LabTestLines."Laboratory Test Name":=LabSpecimenSetup."Test Name";
                               LabTestLines."Specimen Name":=LabSpecimenSetup."Specimen Name";
                               LabTestLines.INSERT;
                            UNTIL LabSpecimenSetup.NEXT=0;
                           END;
                                */
                         // DocLabRequestLines.Status:=DocLabRequestLines.Status::Forwarded;
                          //DocLabRequestLines.MODIFY;
                       until DocLabRequestLines.Next=0;
                    end
                    else
                    begin
                    Error('Nothing to Forward!');
                    end;
                    
                    
                    /*
                    TreatmentHeader.RESET;
                    TreatmentHeader.SETRANGE(TreatmentHeader."Treatment No.","Treatment No.");
                    IF TreatmentHeader.FIND('-') THEN
                       REPORT.RUN(39005793,TRUE,FALSE,TreatmentHeader);
                    */
                    
                      end;

                end;
            }
        }
    }

    var
        LabHeader: Record UnknownRecord61416;
        LabLine: Record UnknownRecord61417;
        TreatmentHeader: Record UnknownRecord61407;
        TreatmentLine: Record UnknownRecord61410;
        Tests: Record UnknownRecord61394;
        SpecimenList: Record UnknownRecord61395;
        HMSSetup: Record UnknownRecord61386;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        DocLabRequestLines: Record UnknownRecord61410;
        LabTestLines: Record UnknownRecord61417;
        Labsetup: Record UnknownRecord61392;
        LabSpecimenSetup: Record UnknownRecord61395;
        labheader2: Record UnknownRecord61416;
}

