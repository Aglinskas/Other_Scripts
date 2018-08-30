fn = '/Users/aidasaglinskas/Downloads/JoshBrmMDS_MASTER_9.5.2014 (1).xlsx'
dt = xlsread(fn)

d = struct;
d.dm = dt(:,1:14);
d.cm = dt(:,15:18);
d.dimLbls = a
d.cLbls = b
d.words = C{1};
save('/Users/aidasaglinskas/Desktop/FeatWordsDB.mat','d')
%%
a = [
    {'Emotion'   }
    {'Polarity'  }
    {'Social'    }
    {'Moral'     }
    {'MotionSelf'}
    {'Thought'   }
    {'Color'     }
    {'TasteSmell'}
    {'Tactile'   }
    {'VisualForm'}
    {'Auditory'  }
    {'Space'     }
    {'Quantity'  }
    {'Time'      }]
%%
b = [{'CNC'}    {'IMG'}    {'FAM'}    {'SUBTL-WordFreq'}]'
%%
fn = '/Users/aidasaglinskas/Desktop/words.txt';
fid = fopen(fn)
C = textscan(fid,'%s')
C{1}
