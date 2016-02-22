function [stamp] = timestamp()

    timedate  = fix(clock);
    stamp = [num2str(timedate(3),'%02d') num2str(timedate(2),'%02d') num2str(timedate(1),'%02d') '_' num2str(timedate(4),'%02d') num2str(timedate(5),'%02d') num2str(timedate(6),'%02d')];

end

