#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60010 "ELECT-Elections Header List"
{
    ApplicationArea = Basic;
    CardPageID = "ELECT-Elections Header Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60000;
    SourceTableView = where(Status=filter(<>Closed));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Election Code";"Election Code")
                {
                    ApplicationArea = Basic;
                }
                field("Election Date";"Election Date")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Election Description";"Election Description")
                {
                    ApplicationArea = Basic;
                }
                field("Election Approach";"Election Approach")
                {
                    ApplicationArea = Basic;
                }
                field("Voting Method";"Voting Method")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Choice";"Voter Choice")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Abstain";"Allow Abstain")
                {
                    ApplicationArea = Basic;
                }
                field("Abstain Candidate";"Abstain Candidate")
                {
                    ApplicationArea = Basic;
                }
                field("Active Students only";"Active Students only")
                {
                    ApplicationArea = Basic;
                }
                field(vo;"Candidate Balance Based on")
                {
                    ApplicationArea = Basic;
                }
                field("Candicate Balance";"Candicate Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Balance Based on";"Voter Balance Based on")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Balance";"Voter Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Registration Method";"Voter Registration Method")
                {
                    ApplicationArea = Basic;
                }
                field("Registered Voters";"Registered Voters")
                {
                    ApplicationArea = Basic;
                }
                field("Eligible Voters";"Eligible Voters")
                {
                    ApplicationArea = Basic;
                }
                field("Total Voted";"Total Voted")
                {
                    ApplicationArea = Basic;
                }
                field("Did not Vote";"Did not Vote")
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
        area(creation)
        {
            group(Setups)
            {
                Caption = 'Setup';
                Image = Setup;
                action(PositionCats)
                {
                    ApplicationArea = Basic;
                    Caption = 'Position Categories/Groups';
                    Image = GLJournal;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ELECT-Position Categories List";
                    RunPageLink = "Election Code"=field("Election Code");
                }
                action(ElectralDistr)
                {
                    ApplicationArea = Basic;
                    Caption = 'Electral Districts';
                    Image = AddWatch;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ELECT-Electral Districts List";
                    RunPageLink = "Election Code"=field("Election Code");
                }
                action(VotingReg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Voter Register';
                    Image = Register;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "ELECT-Voter Register List";
                    RunPageLink = "Election Code"=field("Election Code");
                }
                action("Election Setups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Election Setups';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "ELECT-Elections Setup";
                }
            }
        }
        area(processing)
        {
            group(Activities)
            {
                Caption = 'Periodic Activites';
                Image = Dimensions;
                action(AllowApplic)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allow Applications';
                    Image = Allocate;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    var
                        NoSeriesManagement: Codeunit NoSeriesManagement;
                        MaleCounts: Integer;
                        MalePosition: Integer;
                        ELECTResultsRankings: Record UnknownRecord60010;
                        ACACourseRegistration: Record UnknownRecord61532;
                        Customersz: Record Customer;
                    begin
                        //IF "Election Date"
                        if Confirm('Allow application?',true)=false then Error('Cancelled by user');
                                      ELECTMyPositions.Reset;
                                      ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                                      if ELECTMyPositions.Find('-') then
                                        ELECTMyPositions.DeleteAll; //Clear all Positions for the Voters

                        if Rec."Voter Registration Method"=Rec."voter registration method"::"Automated  Registration" then begin
                            //Pick All Active Students

                        // // //            ELECTVoterRegister.RESET;
                        // // //            ELECTVoterRegister.SETRANGE("Election Code",Rec."Election Code");
                        // // //            IF ELECTVoterRegister.FIND('-') THEN ELECTVoterRegister.DELETEALL;

                          if Confirm('Update Voter register automaticall?',true) then begin
                          ACACourseRegistration.Reset;
                          ACACourseRegistration.SetRange(Semester,Rec.Semester);
                          ACACourseRegistration.SetFilter(ACACourseRegistration.Reversed,'%1',false);
                          ACACourseRegistration.SetFilter("Student No.",'<>%1','');
                          ACACourseRegistration.SetFilter(Programme,'<>%1','');
                          ACACourseRegistration.SetFilter(Posted,'=%1',true);
                          if ACACourseRegistration.Find('-') then begin
                            //Check if Policy is met for the student
                            repeat
                              begin
                              Customersz.Reset;
                              Customersz.SetRange("No.",ACACourseRegistration."Student No.");
                              if Customersz.Find('-') then begin
                                    ELECTVoterRegister.Reset;
                                    ELECTVoterRegister.SetRange("Election Code",Rec."Election Code");
                                    ELECTVoterRegister.SetRange("Voter No.",ACACourseRegistration."Student No.");
                                    if not (ELECTVoterRegister.Find('-')) then begin
                                      ELECTVoterRegister.Init;
                                      ELECTVoterRegister."Election Code":=Rec."Election Code";
                                      ELECTVoterRegister."Voter No.":=ACACourseRegistration."Student No.";
                                      ELECTVoterRegister."Polling Center Code":=Rec."Default Polling Station";
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Voter No.");
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Polling Center Code");
                                      ELECTVoterRegister.Insert;

                                      end;
                                      end;
                              end;
                              until ACACourseRegistration.Next=0;
                            end;
                          end;
                          end else if  Rec."Voter Registration Method"=Rec."voter registration method"::"From Delegates" then begin
                            //Clear The voter Register and Pick
                            if ((Rec."Delegates Election"=true) and (Rec."Delegate Election Reference"<>'')) then begin
                              //Populate Voters from Degates
                              ELECTElectionsHeader.Reset;
                              ELECTElectionsHeader.SetRange("Election Code",Rec."Delegate Election Reference");
                              if ELECTElectionsHeader.Find('-') then begin
                                if ELECTElectionsHeader.Status<>ELECTElectionsHeader.Status::Closed then Error('The Delegates Election specified is not yet closed');
                                  if ELECTElectionsHeader."Election Date"<Today then Error('The specified Election for Delegates is not yet carried out');
                                  ELECTPositions.Reset;
                                  ELECTPositions.SetRange("Election Code",Rec."Delegate Election Reference");
                                  ELECTPositions.SetFilter("isDelegate?",'%1',true);
                                  if ELECTPositions.Find('-') then begin
                                    repeat
                                      begin
                                    Clear(CountedFemaleInTop);
                                    Clear(CountedMaleInTop);
                                    Clear(countedPosts);
                                    //Exists Delegate Election Positions

                                    if ((ELECTPositions."Number of Nominees/Voter">0) and (ELECTPositions."Highest Nominee No. One Gender">0)) then begin
                                      //Get Number of Males and Females to Register
                                    ELECTResults.Reset;
                                    ELECTResults.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTResults.SetRange("Position Code",ELECTPositions."Position Code");
                                    ELECTResults.SetCurrentkey(ELECTResults."Election Code",ELECTResults."Position Code",ELECTResults.Ranking);
                                    if ELECTResults.Find('-') then begin
                                    repeat
                                      ELECTResults.CalcFields(Gender);
                                      if ELECTResults.Gender=ELECTResults.Gender::Male then begin
                                        if  (((CountedMaleInTop<ELECTPositions."Highest Nominee No. One Gender") and
                                          (CountedMaleInTop<(ELECTPositions."Number of Nominees/Voter"-ELECTPositions."Highest Nominee No. One Gender"))) and
                                          ((CountedFemaleInTop<ELECTPositions."Highest Nominee No. One Gender") or
                                          (CountedFemaleInTop=ELECTPositions."Highest Nominee No. One Gender"))) then begin
                                          CountedMaleInTop:=CountedMaleInTop+1;
                                          end;
                                        end else if ELECTResults.Gender=ELECTResults.Gender::Female then begin
                                        if  (((CountedFemaleInTop<ELECTPositions."Highest Nominee No. One Gender") and
                                          (CountedFemaleInTop<(ELECTPositions."Number of Nominees/Voter"-ELECTPositions."Highest Nominee No. One Gender"))) and
                                          ((CountedMaleInTop<ELECTPositions."Highest Nominee No. One Gender") or
                                          (CountedMaleInTop=ELECTPositions."Highest Nominee No. One Gender"))) then begin
                                          CountedFemaleInTop:=CountedFemaleInTop+1;
                                          end;
                                          end;
                                    begin
                                    end
                                      until ((ELECTResults.Next=0) or ((CountedFemaleInTop+CountedMaleInTop)=ELECTPositions."Number of Nominees/Voter"))
                                      end;
                                      if CountedMaleInTop>0 then  begin
                                      /////// Counted Females and Males achieved
                                     // Pick Males AND Insert..................................................... ELECTResultsRankings.RESET;
                                    ELECTResultsRankings.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTResultsRankings.SetRange("Position Code",ELECTPositions."Position Code");
                                    ELECTResultsRankings.SetFilter(Gender,'%1',ELECTResultsRankings.Gender::Male);
                                    ELECTResultsRankings.SetCurrentkey(ELECTResultsRankings."Election Code",ELECTResultsRankings."Position Code",ELECTResultsRankings.Ranking);
                                    if ELECTResultsRankings.Find('-') then begin
                                    repeat
                                    begin
                                    countedPosts:=countedPosts+1;
                                    ELECTVoterRegister.Reset;
                                    ELECTVoterRegister.SetRange("Election Code",Rec."Election Code");
                                    ELECTVoterRegister.SetRange("Voter No.",ELECTResultsRankings."Candidate No.");
                                    if not (ELECTVoterRegister.Find('-')) then begin

                                      ELECTVoterRegister.Init;
                                    ELECTVoterRegister1.Reset;
                                    ELECTVoterRegister1.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTVoterRegister1.SetRange("Voter No.",ELECTResultsRankings."Candidate No.");
                                    if ELECTVoterRegister1.Find('-') then;

                                      ELECTVoterRegister."Election Code":=Rec."Election Code";
                        // //              ELECTVoterRegister."Electral District":=ELECTVoterRegister1."Electral District";
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Electral District");
                                      ELECTVoterRegister."Voter No.":=ELECTResultsRankings."Candidate No.";
                                      ELECTVoterRegister."Polling Center Code":=Rec."Default Polling Station";
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Voter No.");
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Polling Center Code");
                                      ELECTVoterRegister.Insert;


                                      ///////////////////////////////////
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Voter No.",ELECTResultsRankings."Candidate No.");
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Polling Center Code",Rec."Default Polling Station");
                        // //              ELECTVoterRegister.INSERT;
                                      end;
                                    end;
                                    until ((ELECTResultsRankings.Next=0) or (countedPosts=CountedMaleInTop));
                                    end;
                                    end;
                                     //................................................Males......................

                                      if CountedFemaleInTop>0  then begin
                                      /////// Counted Females and Females achieved
                                     // Pick Females AND Insert*********************************************** ELECTResultsRankings.RESET;
                                    ELECTResultsRankings.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTResultsRankings.SetRange("Position Code",ELECTPositions."Position Code");
                                    ELECTResultsRankings.SetFilter(Gender,'%1',ELECTResultsRankings.Gender::Female);
                                    ELECTResultsRankings.SetCurrentkey(ELECTResultsRankings."Election Code",ELECTResultsRankings."Position Code",ELECTResultsRankings.Ranking);
                                    if ELECTResultsRankings.Find('-') then begin
                                    repeat
                                    begin
                                    countedPosts:=countedPosts+1;
                                    ELECTVoterRegister.Reset;
                                    ELECTVoterRegister.SetRange("Election Code",Rec."Election Code");
                                    ELECTVoterRegister.SetRange("Voter No.",ELECTResultsRankings."Candidate No.");
                                    if not (ELECTVoterRegister.Find('-')) then begin
                                      ELECTVoterRegister.Init;
                                    ELECTVoterRegister1.Reset;
                                    ELECTVoterRegister1.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTVoterRegister1.SetRange("Voter No.",ELECTResultsRankings."Candidate No.");
                                    if ELECTVoterRegister1.Find('-') then;

                                      ELECTVoterRegister."Election Code":=Rec."Election Code";
                        //              ELECTVoterRegister."Electral District":=ELECTVoterRegister1."Electral District";
                        //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Electral District");
                                      ELECTVoterRegister."Voter No.":=ELECTResultsRankings."Candidate No.";
                                      ELECTVoterRegister."Polling Center Code":=Rec."Default Polling Station";
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Voter No.");
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Polling Center Code");
                                      ELECTVoterRegister.Insert;


                                      ///////////////////////////////////
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Voter No.",ELECTResultsRankings."Candidate No.");
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Polling Center Code",Rec."Default Polling Station");
                        // //              ELECTVoterRegister.INSERT;
                                      end;
                                    end;
                                    until ((ELECTResultsRankings.Next=0) or (countedPosts=CountedFemaleInTop));
                                    end;
                                    end;
                                     //***********************************************************Females***************************
                                      end else begin
                                    ELECTResultsRankings.Reset;
                                    ELECTResultsRankings.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTResultsRankings.SetRange("Position Code",ELECTPositions."Position Code");
                                    ELECTResultsRankings.SetCurrentkey(ELECTResultsRankings."Election Code",ELECTResultsRankings."Position Code",ELECTResultsRankings.Ranking);
                                    if ELECTResultsRankings.Find('-') then begin
                                    repeat
                                    begin
                                    countedPosts:=countedPosts+1;
                                    ELECTVoterRegister.Reset;
                                    ELECTVoterRegister.SetRange("Election Code",Rec."Election Code");
                                    ELECTVoterRegister.SetRange("Voter No.",ELECTResultsRankings."Candidate No.");
                                    if not (ELECTVoterRegister.Find('-')) then begin

                                      ELECTVoterRegister.Init;
                                    ELECTVoterRegister1.Reset;
                                    ELECTVoterRegister1.SetRange("Election Code",Rec."Delegate Election Reference");
                                    ELECTVoterRegister1.SetRange("Voter No.",ELECTResultsRankings."Candidate No.");
                                    if ELECTVoterRegister1.Find('-') then;

                                      ELECTVoterRegister."Election Code":=Rec."Election Code";
                        //              ELECTVoterRegister."Electral District":=ELECTVoterRegister1."Electral District";
                        //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Electral District");
                                      ELECTVoterRegister."Voter No.":=ELECTResultsRankings."Candidate No.";
                                      ELECTVoterRegister."Polling Center Code":=Rec."Default Polling Station";
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Voter No.");
                                      ELECTVoterRegister.Validate(ELECTVoterRegister."Polling Center Code");
                                      ELECTVoterRegister.Insert;


                                      ///////////////////////////////////
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Voter No.",ELECTResultsRankings."Candidate No.");
                        // //              ELECTVoterRegister.VALIDATE(ELECTVoterRegister."Polling Center Code",Rec."Default Polling Station");
                        // //              ELECTVoterRegister.INSERT;
                                      end;
                                    end;
                                    until ((ELECTResultsRankings.Next=0) or (countedPosts=ELECTPositions."Number of Nominees/Voter"));
                                    end;
                                    end;
                                      end;
                                    until ELECTPositions.Next=0;
                                    end;
                                end;
                              end;
                            end;

                        if Today>Rec."Candidature Application End" then Error('Its past application deadline of '+Format(Rec."Candidature Application End"));
                        Rec."Applications Allowed":=true;
                        ELECTVoterRegister.Reset;
                        ELECTVoterRegister.SetRange("Election Code",Rec."Election Code");
                        ELECTVoterRegister.SetFilter(Eligible,'%1',true);
                        ELECTVoterRegister.SetFilter("Manual Eligibility to Contest",'%1',true);
                        if ELECTVoterRegister.Find('-') then begin
                          //Loop through all Voters Picking eligible Voters to create My Positions and My Candidates
                          repeat
                            begin
                            if ELECTVoterRegister."Voter No." = 'A100/0014G/17' then
                              ELECTPositions.Reset;
                            if ELECTVoterRegister."Ballot ID"='' then begin
                              ELECTVoterRegister."Ballot ID" := NoSeriesManagement.GetNextNo("Ballot ID Numbers",Today,true);
                              ELECTVoterRegister.Modify;
                              end;
                              ELECTPositions.Reset;
                              ELECTPositions.SetRange("Election Code",Rec."Election Code");
                              ELECTPositions.SetFilter("Position Code",'<>%1','');
                              if ELECTPositions.Find('-') then begin
                                repeat
                                  begin
                                    if ELECTPositions."Position Scope"=ELECTPositions."position scope"::"Overal Position" then begin
                                      //Insert for the Voter Irespective of some other parameters like Dept
                                      ELECTMyPositions.Reset;
                                      ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                                      ELECTMyPositions.SetRange("Position Code",ELECTPositions."Position Code");
                                      ELECTMyPositions.SetRange("Voter No.",ELECTVoterRegister."Voter No.");
                                      if not ELECTMyPositions.Find('-') then begin
                                        ELECTMyPositions.Init;
                                        ELECTMyPositions."Election Code":=Rec."Election Code";
                                        ELECTMyPositions."Position Code":=ELECTPositions."Position Code";
                                        ELECTMyPositions."Voter No.":=ELECTVoterRegister."Voter No.";
                                        ELECTMyPositions.Insert;
                                      end;
                                      end else if  ELECTPositions."Position Scope"=ELECTPositions."position scope"::"School Position" then begin
                                        if ELECTPositions."School Code"=ELECTVoterRegister."School Code" then begin
                                          //Insert the Position for a Voter since its in the same school as a voter
                                      ELECTMyPositions.Reset;
                                      ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                                      ELECTMyPositions.SetRange("Position Code",ELECTPositions."Position Code");
                                      ELECTMyPositions.SetRange("Voter No.",ELECTVoterRegister."Voter No.");
                                      if not ELECTMyPositions.Find('-') then begin
                                          ELECTMyPositions.Init;
                                          ELECTMyPositions."Election Code":=Rec."Election Code";
                                          ELECTMyPositions."Position Code":=ELECTPositions."Position Code";
                                          ELECTMyPositions."Voter No.":=ELECTVoterRegister."Voter No.";
                                          ELECTMyPositions.Insert;
                                          end;
                                          end;
                                      end else if ELECTPositions."Position Scope"=ELECTPositions."position scope"::"Campus Position" then begin
                                        if ELECTPositions."Campus Code"=ELECTVoterRegister."Campus Code" then begin
                                          //Insert the Position for a Voter since its in the same school as a voter
                                      ELECTMyPositions.Reset;
                                      ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                                      ELECTMyPositions.SetRange("Position Code",ELECTPositions."Position Code");
                                      ELECTMyPositions.SetRange("Voter No.",ELECTVoterRegister."Voter No.");
                                      if not ELECTMyPositions.Find('-') then begin
                                          ELECTMyPositions.Init;
                                          ELECTMyPositions."Election Code":=Rec."Election Code";
                                          ELECTMyPositions."Position Code":=ELECTPositions."Position Code";
                                          ELECTMyPositions."Voter No.":=ELECTVoterRegister."Voter No.";
                                          ELECTMyPositions.Insert;
                                          end;
                                          end;
                                      end else if ELECTPositions."Position Scope"=ELECTPositions."position scope"::"Departmental Position" then begin
                                        if ELECTPositions."Department Code"=ELECTVoterRegister."Department Code" then begin
                                          //Insert the Position for a Voter since its in the same school as a voter
                                      ELECTMyPositions.Reset;
                                      ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                                      ELECTMyPositions.SetRange("Position Code",ELECTPositions."Position Code");
                                      ELECTMyPositions.SetRange("Voter No.",ELECTVoterRegister."Voter No.");
                                      if not ELECTMyPositions.Find('-') then begin
                                          ELECTMyPositions.Init;
                                          ELECTMyPositions."Election Code":=Rec."Election Code";
                                          ELECTMyPositions."Position Code":=ELECTPositions."Position Code";
                                          ELECTMyPositions."Voter No.":=ELECTVoterRegister."Voter No.";
                                          ELECTMyPositions.Insert;
                                          end;
                                          end;
                                      end else if ELECTPositions."Position Scope"=ELECTPositions."position scope"::"Electral District Position" then begin
                                        if ELECTPositions."Electral District"=ELECTVoterRegister."Electral District" then begin
                                          //Insert the Position for a Voter since its in the same school as a voter
                                      ELECTMyPositions.Reset;
                                      ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                                      ELECTMyPositions.SetRange("Position Code",ELECTPositions."Position Code");
                                      ELECTMyPositions.SetRange("Voter No.",ELECTVoterRegister."Voter No.");
                                      if not ELECTMyPositions.Find('-') then begin
                                          ELECTMyPositions.Init;
                                          ELECTMyPositions."Election Code":=Rec."Election Code";
                                          ELECTMyPositions."Position Code":=ELECTPositions."Position Code";
                                          ELECTMyPositions."Voter No.":=ELECTVoterRegister."Voter No.";
                                          ELECTMyPositions.Insert;
                                          end;
                                          end;
                                      end;
                                  end;
                                    until ELECTPositions.Next=0;
                                end;
                            end;
                              until ELECTVoterRegister.Next=0;
                          end;
                          Message('Voter Positions updated successfully!');
                    end;
                }
                action(AllowVoting)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allow Voting';
                    Image = Approvals;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                         if Confirm('If allow Voting?',true)=false then Error('Cancelled by user');
                         if ((Today>Rec."Election Date")) then Error('The election dates are Past');
                                  ELECTMyCandidates.Reset;
                                  ELECTMyCandidates.SetRange("Election Code",Rec."Election Code");
                                  if ELECTMyCandidates.Find('-') then ELECTMyCandidates.DeleteAll;

                        Rec."Voting Allowed":=true;
                         ELECTMyPositions.Reset;
                         ELECTMyPositions.SetRange("Election Code",Rec."Election Code");
                         if ELECTMyPositions.Find('-') then begin
                           repeat
                             begin
                              ELECTCandidates.Reset;
                              ELECTCandidates.SetRange("Election Code",Rec."Election Code");
                              ELECTCandidates.SetRange("Position Code",ELECTMyPositions."Position Code");
                              if ELECTCandidates.Find('-') then begin
                                repeat
                                  begin
                                  ELECTMyCandidates.Reset;
                                  ELECTMyCandidates.SetRange("Election Code",Rec."Election Code");
                                  ELECTMyCandidates.SetRange("Position Code",ELECTMyPositions."Position Code");
                                  ELECTMyCandidates.SetRange("Voter No.",ELECTMyPositions."Voter No.");
                                  ELECTMyCandidates.SetRange("Candidate No.",ELECTCandidates."Candidate No.");
                                  if not ELECTMyCandidates.Find('-') then begin
                                    ELECTMyCandidates.Init;
                                    ELECTMyCandidates."Election Code":=Rec."Election Code";
                                    ELECTMyCandidates."Position Code":=ELECTMyPositions."Position Code";
                                    ELECTMyCandidates."Voter No.":=ELECTMyPositions."Voter No.";
                                    ELECTMyCandidates."Candidate No.":=ELECTCandidates."Candidate No.";
                                    ELECTMyCandidates.Insert;
                        // // //            Customer.RESET;
                        // // //            Customer.SETRANGE("No.",ELECTMyPositions."Candidate No.");
                        // // //            IF Customer.FIND('-') THEN
                        // // //            ELECTMyCandidates."Candidate Name":=Customer.Name;
                                    end;
                                    end;
                                    until ELECTCandidates.Next=0;
                                end;
                             end;
                               until ELECTMyPositions.Next=0;
                           end;

                        Message('Votting allowed successfully');
                    end;
                }
                action(RankCandidates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rank Candidate';
                    Image = ExecuteAndPostBatch;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange("Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then begin
                         Report.Run(60010,false,false,ELECTPositions);
                         Report.Run(60011,false,false,ELECTPositions);
                          end;
                    end;
                }
                action(CloseElection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Close Election';
                    Image = ClosePeriod;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        if not (("Election Date"=Today) or (Today>"Election Date")) then Error('The Elections id not due');
                        if Confirm('Process results before clossing?',true)=true then begin
                         // Rank Candidates
                        // //  ELECTPositions.RESET;
                        // // ELECTPositions.SETRANGE("Election Code",Rec."Election Code");
                        // // IF ELECTPositions.FIND('-') THEN BEGIN
                        // //  REPORT.RUN(60010,FALSE,FALSE,ELECTPositions);
                        // //  REPORT.RUN(60011,FALSE,FALSE,ELECTPositions);
                        // //  END;
                          end;
                        Status:=Status::Closed;
                        Modify;
                        Message('Election Closed');
                        //CurrPage.UPDATE;
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                action(VoterRegister)
                {
                    ApplicationArea = Basic;
                    Caption = 'Voter Register';
                    Image = RegisteredDocs;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ELECTPollingCenters.Reset;
                        ELECTPollingCenters.SetRange(ELECTPollingCenters."Election Code",Rec."Election Code");
                        if ELECTPollingCenters.Find('-') then begin
                          Report.Run(60009,true,false,ELECTPollingCenters);
                          end;
                    end;
                }
                action(Agents)
                {
                    ApplicationArea = Basic;
                    Caption = 'Agents';
                    Image = Aging;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ELECTElectralDistricts.Reset;
                        ELECTElectralDistricts.SetRange(ELECTElectralDistricts."Election Code",Rec."Election Code");
                        if ELECTElectralDistricts.Find('-') then begin
                          Report.Run(60013,true,false,ELECTElectralDistricts);
                          end;
                    end;
                }
                action(BallotPapers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ballot Papers';
                    Image = Documents;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange(ELECTPositions."Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then Report.Run(60014,true,false);
                    end;
                }
                action(ResultsSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'Results Summary';
                    Image = SuggestGrid;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange(ELECTPositions."Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then Report.Run(60015,true,false);
                    end;
                }
                action(Winners)
                {
                    ApplicationArea = Basic;
                    Caption = 'Election Winners';
                    Image = AddToHome;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange(ELECTPositions."Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then Report.Run(60016,true,false);
                    end;
                }
            }
        }
    }

    var
        ELECTMyPositions: Record UnknownRecord60011;
        ELECTMyCandidates: Record UnknownRecord60012;
        ELECTVoterRegister: Record UnknownRecord60002;
        ELECTVoterRegister1: Record UnknownRecord60002;
        ELECTPositions: Record UnknownRecord60001;
        ELECTCandidates: Record UnknownRecord60006;
        Customer: Record Customer;
        ELECTElectralDistricts: Record UnknownRecord60004;
        ELECTPollingCenters: Record UnknownRecord60008;
        ELECTElectionsHeader: Record UnknownRecord60000;
        countedPosts: Integer;
        NoOfNominees: Integer;
        SuperiorNumbers: Integer;
        InferiorNumbers: Integer;
        SuperiorGender: Code[10];
        InferiorGender: Code[10];
        CountedMaleInTop: Integer;
        CountedFemaleInTop: Integer;
        SuperiorFound: Boolean;
        ELECTResults: Record UnknownRecord60010;
        ELECTResultsMales: Record UnknownRecord60010;
        ELECTResultsFemales: Record UnknownRecord60010;
}

