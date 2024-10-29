
_shm_cnt:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
   struct uspinlock lock;
   int cnt;
};

int main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	push   -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	57                   	push   %edi
    100e:	56                   	push   %esi
    100f:	53                   	push   %ebx
    1010:	51                   	push   %ecx
    1011:	83 ec 18             	sub    $0x18,%esp
int pid;
int i=0;
struct shm_cnt *counter;
  pid=fork();
    1014:	e8 32 03 00 00       	call   134b <fork>
  sleep(1);
    1019:	83 ec 0c             	sub    $0xc,%esp
    101c:	6a 01                	push   $0x1
  pid=fork();
    101e:	89 c7                	mov    %eax,%edi
  sleep(1);
    1020:	e8 be 03 00 00       	call   13e3 <sleep>

//shm_open: first process will create the page, the second will just attach to the same page
//we get the virtual address of the page returned into counter
//which we can now use but will be shared between the two processes
  
shm_open(1,(char **)&counter);
    1025:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1028:	5b                   	pop    %ebx
    1029:	5e                   	pop    %esi
    102a:	50                   	push   %eax
 
  printf(1,"%s returned successfully from shm_open with counter %x\n", pid? "Child": "Parent", counter); 
    102b:	be 2a 18 00 00       	mov    $0x182a,%esi
    1030:	bb 24 18 00 00       	mov    $0x1824,%ebx
shm_open(1,(char **)&counter);
    1035:	6a 01                	push   $0x1
    1037:	e8 b7 03 00 00       	call   13f3 <shm_open>
  printf(1,"%s returned successfully from shm_open with counter %x\n", pid? "Child": "Parent", counter); 
    103c:	83 c4 10             	add    $0x10,%esp
    103f:	89 f0                	mov    %esi,%eax
    1041:	85 ff                	test   %edi,%edi
    1043:	0f 45 c3             	cmovne %ebx,%eax
    1046:	ff 75 e4             	push   -0x1c(%ebp)
    1049:	50                   	push   %eax
    104a:	68 64 18 00 00       	push   $0x1864
    104f:	6a 01                	push   $0x1
    1051:	e8 6a 04 00 00       	call   14c0 <printf>
  for(i = 0; i < 10000; i++)
    1056:	83 c4 10             	add    $0x10,%esp
    1059:	85 ff                	test   %edi,%edi
    105b:	0f 44 f3             	cmove  %ebx,%esi
    105e:	31 db                	xor    %ebx,%ebx
    {
     //printf(1,"Here is i: %d \n", i);
     uacquire(&(counter->lock));
    1060:	83 ec 0c             	sub    $0xc,%esp
    1063:	ff 75 e4             	push   -0x1c(%ebp)
    1066:	e8 85 07 00 00       	call   17f0 <uacquire>
     //printf(1,"in count \n");
     counter->cnt++;
    106b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    106e:	83 40 04 01          	addl   $0x1,0x4(%eax)
     //printf(1,"in count \n");
     urelease(&(counter->lock));
    1072:	89 04 24             	mov    %eax,(%esp)
    1075:	e8 96 07 00 00       	call   1810 <urelease>
    107a:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
    1080:	83 c4 10             	add    $0x10,%esp
    1083:	c1 c8 03             	ror    $0x3,%eax
     //printf(,"out count \n");
//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
    1086:	3d 37 89 41 00       	cmp    $0x418937,%eax
    108b:	77 1a                	ja     10a7 <main+0xa7>
       printf(1,"Counter in %s is %d at address %x\n",pid? "Parent" : "Child", counter->cnt, counter);
    108d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1090:	83 ec 0c             	sub    $0xc,%esp
    1093:	50                   	push   %eax
    1094:	ff 70 04             	push   0x4(%eax)
    1097:	56                   	push   %esi
    1098:	68 9c 18 00 00       	push   $0x189c
    109d:	6a 01                	push   $0x1
    109f:	e8 1c 04 00 00       	call   14c0 <printf>
    10a4:	83 c4 20             	add    $0x20,%esp
  for(i = 0; i < 10000; i++)
    10a7:	83 c3 01             	add    $0x1,%ebx
    10aa:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    10b0:	75 ae                	jne    1060 <main+0x60>
}
  
  if(pid)
     {
       printf(1,"Counter in parent is %d\n",counter->cnt);
    10b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10b5:	8b 40 04             	mov    0x4(%eax),%eax
  if(pid)
    10b8:	85 ff                	test   %edi,%edi
    10ba:	74 25                	je     10e1 <main+0xe1>
       printf(1,"Counter in parent is %d\n",counter->cnt);
    10bc:	51                   	push   %ecx
    10bd:	50                   	push   %eax
    10be:	68 31 18 00 00       	push   $0x1831
    10c3:	6a 01                	push   $0x1
    10c5:	e8 f6 03 00 00       	call   14c0 <printf>
    wait();
    10ca:	e8 8c 02 00 00       	call   135b <wait>
    10cf:	83 c4 10             	add    $0x10,%esp
    } else
    printf(1,"Counter in child is %d\n\n",counter->cnt);

//shm_close: first process will just detach, next one will free up the shm_table entry (but for now not the page)
   shm_close(1);
    10d2:	83 ec 0c             	sub    $0xc,%esp
    10d5:	6a 01                	push   $0x1
    10d7:	e8 1f 03 00 00       	call   13fb <shm_close>
   exit();
    10dc:	e8 72 02 00 00       	call   1353 <exit>
    printf(1,"Counter in child is %d\n\n",counter->cnt);
    10e1:	52                   	push   %edx
    10e2:	50                   	push   %eax
    10e3:	68 4a 18 00 00       	push   $0x184a
    10e8:	6a 01                	push   $0x1
    10ea:	e8 d1 03 00 00       	call   14c0 <printf>
    10ef:	83 c4 10             	add    $0x10,%esp
    10f2:	eb de                	jmp    10d2 <main+0xd2>
    10f4:	66 90                	xchg   %ax,%ax
    10f6:	66 90                	xchg   %ax,%ax
    10f8:	66 90                	xchg   %ax,%ax
    10fa:	66 90                	xchg   %ax,%ax
    10fc:	66 90                	xchg   %ax,%ax
    10fe:	66 90                	xchg   %ax,%ax

00001100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1100:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1101:	31 c0                	xor    %eax,%eax
{
    1103:	89 e5                	mov    %esp,%ebp
    1105:	53                   	push   %ebx
    1106:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    1110:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1114:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1117:	83 c0 01             	add    $0x1,%eax
    111a:	84 d2                	test   %dl,%dl
    111c:	75 f2                	jne    1110 <strcpy+0x10>
    ;
  return os;
}
    111e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1121:	89 c8                	mov    %ecx,%eax
    1123:	c9                   	leave  
    1124:	c3                   	ret    
    1125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	53                   	push   %ebx
    1134:	8b 55 08             	mov    0x8(%ebp),%edx
    1137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    113a:	0f b6 02             	movzbl (%edx),%eax
    113d:	84 c0                	test   %al,%al
    113f:	75 17                	jne    1158 <strcmp+0x28>
    1141:	eb 3a                	jmp    117d <strcmp+0x4d>
    1143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1147:	90                   	nop
    1148:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    114c:	83 c2 01             	add    $0x1,%edx
    114f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    1152:	84 c0                	test   %al,%al
    1154:	74 1a                	je     1170 <strcmp+0x40>
    p++, q++;
    1156:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
    1158:	0f b6 19             	movzbl (%ecx),%ebx
    115b:	38 c3                	cmp    %al,%bl
    115d:	74 e9                	je     1148 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    115f:	29 d8                	sub    %ebx,%eax
}
    1161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1164:	c9                   	leave  
    1165:	c3                   	ret    
    1166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    116d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
    1170:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    1174:	31 c0                	xor    %eax,%eax
    1176:	29 d8                	sub    %ebx,%eax
}
    1178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    117b:	c9                   	leave  
    117c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
    117d:	0f b6 19             	movzbl (%ecx),%ebx
    1180:	31 c0                	xor    %eax,%eax
    1182:	eb db                	jmp    115f <strcmp+0x2f>
    1184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    118b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    118f:	90                   	nop

00001190 <strlen>:

uint
strlen(char *s)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1196:	80 3a 00             	cmpb   $0x0,(%edx)
    1199:	74 15                	je     11b0 <strlen+0x20>
    119b:	31 c0                	xor    %eax,%eax
    119d:	8d 76 00             	lea    0x0(%esi),%esi
    11a0:	83 c0 01             	add    $0x1,%eax
    11a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    11a7:	89 c1                	mov    %eax,%ecx
    11a9:	75 f5                	jne    11a0 <strlen+0x10>
    ;
  return n;
}
    11ab:	89 c8                	mov    %ecx,%eax
    11ad:	5d                   	pop    %ebp
    11ae:	c3                   	ret    
    11af:	90                   	nop
  for(n = 0; s[n]; n++)
    11b0:	31 c9                	xor    %ecx,%ecx
}
    11b2:	5d                   	pop    %ebp
    11b3:	89 c8                	mov    %ecx,%eax
    11b5:	c3                   	ret    
    11b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11bd:	8d 76 00             	lea    0x0(%esi),%esi

000011c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	57                   	push   %edi
    11c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    11cd:	89 d7                	mov    %edx,%edi
    11cf:	fc                   	cld    
    11d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
    11d5:	89 d0                	mov    %edx,%eax
    11d7:	c9                   	leave  
    11d8:	c3                   	ret    
    11d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000011e0 <strchr>:

char*
strchr(const char *s, char c)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	8b 45 08             	mov    0x8(%ebp),%eax
    11e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    11ea:	0f b6 10             	movzbl (%eax),%edx
    11ed:	84 d2                	test   %dl,%dl
    11ef:	75 12                	jne    1203 <strchr+0x23>
    11f1:	eb 1d                	jmp    1210 <strchr+0x30>
    11f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11f7:	90                   	nop
    11f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    11fc:	83 c0 01             	add    $0x1,%eax
    11ff:	84 d2                	test   %dl,%dl
    1201:	74 0d                	je     1210 <strchr+0x30>
    if(*s == c)
    1203:	38 d1                	cmp    %dl,%cl
    1205:	75 f1                	jne    11f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1207:	5d                   	pop    %ebp
    1208:	c3                   	ret    
    1209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1210:	31 c0                	xor    %eax,%eax
}
    1212:	5d                   	pop    %ebp
    1213:	c3                   	ret    
    1214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    121b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    121f:	90                   	nop

00001220 <gets>:

char*
gets(char *buf, int max)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	57                   	push   %edi
    1224:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1225:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1228:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1229:	31 db                	xor    %ebx,%ebx
{
    122b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    122e:	eb 27                	jmp    1257 <gets+0x37>
    cc = read(0, &c, 1);
    1230:	83 ec 04             	sub    $0x4,%esp
    1233:	6a 01                	push   $0x1
    1235:	57                   	push   %edi
    1236:	6a 00                	push   $0x0
    1238:	e8 2e 01 00 00       	call   136b <read>
    if(cc < 1)
    123d:	83 c4 10             	add    $0x10,%esp
    1240:	85 c0                	test   %eax,%eax
    1242:	7e 1d                	jle    1261 <gets+0x41>
      break;
    buf[i++] = c;
    1244:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1248:	8b 55 08             	mov    0x8(%ebp),%edx
    124b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    124f:	3c 0a                	cmp    $0xa,%al
    1251:	74 1d                	je     1270 <gets+0x50>
    1253:	3c 0d                	cmp    $0xd,%al
    1255:	74 19                	je     1270 <gets+0x50>
  for(i=0; i+1 < max; ){
    1257:	89 de                	mov    %ebx,%esi
    1259:	83 c3 01             	add    $0x1,%ebx
    125c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    125f:	7c cf                	jl     1230 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1268:	8d 65 f4             	lea    -0xc(%ebp),%esp
    126b:	5b                   	pop    %ebx
    126c:	5e                   	pop    %esi
    126d:	5f                   	pop    %edi
    126e:	5d                   	pop    %ebp
    126f:	c3                   	ret    
  buf[i] = '\0';
    1270:	8b 45 08             	mov    0x8(%ebp),%eax
    1273:	89 de                	mov    %ebx,%esi
    1275:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1279:	8d 65 f4             	lea    -0xc(%ebp),%esp
    127c:	5b                   	pop    %ebx
    127d:	5e                   	pop    %esi
    127e:	5f                   	pop    %edi
    127f:	5d                   	pop    %ebp
    1280:	c3                   	ret    
    1281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    128f:	90                   	nop

00001290 <stat>:

int
stat(char *n, struct stat *st)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	56                   	push   %esi
    1294:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1295:	83 ec 08             	sub    $0x8,%esp
    1298:	6a 00                	push   $0x0
    129a:	ff 75 08             	push   0x8(%ebp)
    129d:	e8 f1 00 00 00       	call   1393 <open>
  if(fd < 0)
    12a2:	83 c4 10             	add    $0x10,%esp
    12a5:	85 c0                	test   %eax,%eax
    12a7:	78 27                	js     12d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    12a9:	83 ec 08             	sub    $0x8,%esp
    12ac:	ff 75 0c             	push   0xc(%ebp)
    12af:	89 c3                	mov    %eax,%ebx
    12b1:	50                   	push   %eax
    12b2:	e8 f4 00 00 00       	call   13ab <fstat>
  close(fd);
    12b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12ba:	89 c6                	mov    %eax,%esi
  close(fd);
    12bc:	e8 ba 00 00 00       	call   137b <close>
  return r;
    12c1:	83 c4 10             	add    $0x10,%esp
}
    12c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12c7:	89 f0                	mov    %esi,%eax
    12c9:	5b                   	pop    %ebx
    12ca:	5e                   	pop    %esi
    12cb:	5d                   	pop    %ebp
    12cc:	c3                   	ret    
    12cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    12d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12d5:	eb ed                	jmp    12c4 <stat+0x34>
    12d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12de:	66 90                	xchg   %ax,%ax

000012e0 <atoi>:

int
atoi(const char *s)
{
    12e0:	55                   	push   %ebp
    12e1:	89 e5                	mov    %esp,%ebp
    12e3:	53                   	push   %ebx
    12e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12e7:	0f be 02             	movsbl (%edx),%eax
    12ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
    12ed:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    12f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    12f5:	77 1e                	ja     1315 <atoi+0x35>
    12f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12fe:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1300:	83 c2 01             	add    $0x1,%edx
    1303:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1306:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    130a:	0f be 02             	movsbl (%edx),%eax
    130d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1310:	80 fb 09             	cmp    $0x9,%bl
    1313:	76 eb                	jbe    1300 <atoi+0x20>
  return n;
}
    1315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1318:	89 c8                	mov    %ecx,%eax
    131a:	c9                   	leave  
    131b:	c3                   	ret    
    131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001320 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1320:	55                   	push   %ebp
    1321:	89 e5                	mov    %esp,%ebp
    1323:	57                   	push   %edi
    1324:	8b 45 10             	mov    0x10(%ebp),%eax
    1327:	8b 55 08             	mov    0x8(%ebp),%edx
    132a:	56                   	push   %esi
    132b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    132e:	85 c0                	test   %eax,%eax
    1330:	7e 13                	jle    1345 <memmove+0x25>
    1332:	01 d0                	add    %edx,%eax
  dst = vdst;
    1334:	89 d7                	mov    %edx,%edi
    1336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    133d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1340:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1341:	39 f8                	cmp    %edi,%eax
    1343:	75 fb                	jne    1340 <memmove+0x20>
  return vdst;
}
    1345:	5e                   	pop    %esi
    1346:	89 d0                	mov    %edx,%eax
    1348:	5f                   	pop    %edi
    1349:	5d                   	pop    %ebp
    134a:	c3                   	ret    

0000134b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    134b:	b8 01 00 00 00       	mov    $0x1,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <exit>:
SYSCALL(exit)
    1353:	b8 02 00 00 00       	mov    $0x2,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <wait>:
SYSCALL(wait)
    135b:	b8 03 00 00 00       	mov    $0x3,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <pipe>:
SYSCALL(pipe)
    1363:	b8 04 00 00 00       	mov    $0x4,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <read>:
SYSCALL(read)
    136b:	b8 05 00 00 00       	mov    $0x5,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <write>:
SYSCALL(write)
    1373:	b8 10 00 00 00       	mov    $0x10,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <close>:
SYSCALL(close)
    137b:	b8 15 00 00 00       	mov    $0x15,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    

00001383 <kill>:
SYSCALL(kill)
    1383:	b8 06 00 00 00       	mov    $0x6,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret    

0000138b <exec>:
SYSCALL(exec)
    138b:	b8 07 00 00 00       	mov    $0x7,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    

00001393 <open>:
SYSCALL(open)
    1393:	b8 0f 00 00 00       	mov    $0xf,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret    

0000139b <mknod>:
SYSCALL(mknod)
    139b:	b8 11 00 00 00       	mov    $0x11,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <unlink>:
SYSCALL(unlink)
    13a3:	b8 12 00 00 00       	mov    $0x12,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <fstat>:
SYSCALL(fstat)
    13ab:	b8 08 00 00 00       	mov    $0x8,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <link>:
SYSCALL(link)
    13b3:	b8 13 00 00 00       	mov    $0x13,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <mkdir>:
SYSCALL(mkdir)
    13bb:	b8 14 00 00 00       	mov    $0x14,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <chdir>:
SYSCALL(chdir)
    13c3:	b8 09 00 00 00       	mov    $0x9,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <dup>:
SYSCALL(dup)
    13cb:	b8 0a 00 00 00       	mov    $0xa,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <getpid>:
SYSCALL(getpid)
    13d3:	b8 0b 00 00 00       	mov    $0xb,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <sbrk>:
SYSCALL(sbrk)
    13db:	b8 0c 00 00 00       	mov    $0xc,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <sleep>:
SYSCALL(sleep)
    13e3:	b8 0d 00 00 00       	mov    $0xd,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <uptime>:
SYSCALL(uptime)
    13eb:	b8 0e 00 00 00       	mov    $0xe,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <shm_open>:
SYSCALL(shm_open)
    13f3:	b8 16 00 00 00       	mov    $0x16,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <shm_close>:
SYSCALL(shm_close)	
    13fb:	b8 17 00 00 00       	mov    $0x17,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    
    1403:	66 90                	xchg   %ax,%ax
    1405:	66 90                	xchg   %ax,%ax
    1407:	66 90                	xchg   %ax,%ax
    1409:	66 90                	xchg   %ax,%ax
    140b:	66 90                	xchg   %ax,%ax
    140d:	66 90                	xchg   %ax,%ax
    140f:	90                   	nop

00001410 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	57                   	push   %edi
    1414:	56                   	push   %esi
    1415:	53                   	push   %ebx
    1416:	83 ec 3c             	sub    $0x3c,%esp
    1419:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    141c:	89 d1                	mov    %edx,%ecx
{
    141e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1421:	85 d2                	test   %edx,%edx
    1423:	0f 89 7f 00 00 00    	jns    14a8 <printint+0x98>
    1429:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    142d:	74 79                	je     14a8 <printint+0x98>
    neg = 1;
    142f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1436:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1438:	31 db                	xor    %ebx,%ebx
    143a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    143d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1440:	89 c8                	mov    %ecx,%eax
    1442:	31 d2                	xor    %edx,%edx
    1444:	89 cf                	mov    %ecx,%edi
    1446:	f7 75 c4             	divl   -0x3c(%ebp)
    1449:	0f b6 92 20 19 00 00 	movzbl 0x1920(%edx),%edx
    1450:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1453:	89 d8                	mov    %ebx,%eax
    1455:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1458:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    145b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    145e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1461:	76 dd                	jbe    1440 <printint+0x30>
  if(neg)
    1463:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1466:	85 c9                	test   %ecx,%ecx
    1468:	74 0c                	je     1476 <printint+0x66>
    buf[i++] = '-';
    146a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    146f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1471:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1476:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1479:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    147d:	eb 07                	jmp    1486 <printint+0x76>
    147f:	90                   	nop
    putc(fd, buf[i]);
    1480:	0f b6 13             	movzbl (%ebx),%edx
    1483:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1486:	83 ec 04             	sub    $0x4,%esp
    1489:	88 55 d7             	mov    %dl,-0x29(%ebp)
    148c:	6a 01                	push   $0x1
    148e:	56                   	push   %esi
    148f:	57                   	push   %edi
    1490:	e8 de fe ff ff       	call   1373 <write>
  while(--i >= 0)
    1495:	83 c4 10             	add    $0x10,%esp
    1498:	39 de                	cmp    %ebx,%esi
    149a:	75 e4                	jne    1480 <printint+0x70>
}
    149c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    149f:	5b                   	pop    %ebx
    14a0:	5e                   	pop    %esi
    14a1:	5f                   	pop    %edi
    14a2:	5d                   	pop    %ebp
    14a3:	c3                   	ret    
    14a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    14a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    14af:	eb 87                	jmp    1438 <printint+0x28>
    14b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14bf:	90                   	nop

000014c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14c0:	55                   	push   %ebp
    14c1:	89 e5                	mov    %esp,%ebp
    14c3:	57                   	push   %edi
    14c4:	56                   	push   %esi
    14c5:	53                   	push   %ebx
    14c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    14cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    14cf:	0f b6 13             	movzbl (%ebx),%edx
    14d2:	84 d2                	test   %dl,%dl
    14d4:	74 6a                	je     1540 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    14d6:	8d 45 10             	lea    0x10(%ebp),%eax
    14d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    14dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    14df:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    14e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    14e4:	eb 36                	jmp    151c <printf+0x5c>
    14e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14ed:	8d 76 00             	lea    0x0(%esi),%esi
    14f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    14f3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    14f8:	83 f8 25             	cmp    $0x25,%eax
    14fb:	74 15                	je     1512 <printf+0x52>
  write(fd, &c, 1);
    14fd:	83 ec 04             	sub    $0x4,%esp
    1500:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1503:	6a 01                	push   $0x1
    1505:	57                   	push   %edi
    1506:	56                   	push   %esi
    1507:	e8 67 fe ff ff       	call   1373 <write>
    150c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    150f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1512:	0f b6 13             	movzbl (%ebx),%edx
    1515:	83 c3 01             	add    $0x1,%ebx
    1518:	84 d2                	test   %dl,%dl
    151a:	74 24                	je     1540 <printf+0x80>
    c = fmt[i] & 0xff;
    151c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    151f:	85 c9                	test   %ecx,%ecx
    1521:	74 cd                	je     14f0 <printf+0x30>
      }
    } else if(state == '%'){
    1523:	83 f9 25             	cmp    $0x25,%ecx
    1526:	75 ea                	jne    1512 <printf+0x52>
      if(c == 'd'){
    1528:	83 f8 25             	cmp    $0x25,%eax
    152b:	0f 84 07 01 00 00    	je     1638 <printf+0x178>
    1531:	83 e8 63             	sub    $0x63,%eax
    1534:	83 f8 15             	cmp    $0x15,%eax
    1537:	77 17                	ja     1550 <printf+0x90>
    1539:	ff 24 85 c8 18 00 00 	jmp    *0x18c8(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1540:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1543:	5b                   	pop    %ebx
    1544:	5e                   	pop    %esi
    1545:	5f                   	pop    %edi
    1546:	5d                   	pop    %ebp
    1547:	c3                   	ret    
    1548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    154f:	90                   	nop
  write(fd, &c, 1);
    1550:	83 ec 04             	sub    $0x4,%esp
    1553:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1556:	6a 01                	push   $0x1
    1558:	57                   	push   %edi
    1559:	56                   	push   %esi
    155a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    155e:	e8 10 fe ff ff       	call   1373 <write>
        putc(fd, c);
    1563:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1567:	83 c4 0c             	add    $0xc,%esp
    156a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    156d:	6a 01                	push   $0x1
    156f:	57                   	push   %edi
    1570:	56                   	push   %esi
    1571:	e8 fd fd ff ff       	call   1373 <write>
        putc(fd, c);
    1576:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1579:	31 c9                	xor    %ecx,%ecx
    157b:	eb 95                	jmp    1512 <printf+0x52>
    157d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1580:	83 ec 0c             	sub    $0xc,%esp
    1583:	b9 10 00 00 00       	mov    $0x10,%ecx
    1588:	6a 00                	push   $0x0
    158a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    158d:	8b 10                	mov    (%eax),%edx
    158f:	89 f0                	mov    %esi,%eax
    1591:	e8 7a fe ff ff       	call   1410 <printint>
        ap++;
    1596:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    159a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    159d:	31 c9                	xor    %ecx,%ecx
    159f:	e9 6e ff ff ff       	jmp    1512 <printf+0x52>
    15a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    15a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    15ab:	8b 10                	mov    (%eax),%edx
        ap++;
    15ad:	83 c0 04             	add    $0x4,%eax
    15b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    15b3:	85 d2                	test   %edx,%edx
    15b5:	0f 84 8d 00 00 00    	je     1648 <printf+0x188>
        while(*s != 0){
    15bb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    15be:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    15c0:	84 c0                	test   %al,%al
    15c2:	0f 84 4a ff ff ff    	je     1512 <printf+0x52>
    15c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    15cb:	89 d3                	mov    %edx,%ebx
    15cd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    15d0:	83 ec 04             	sub    $0x4,%esp
          s++;
    15d3:	83 c3 01             	add    $0x1,%ebx
    15d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    15d9:	6a 01                	push   $0x1
    15db:	57                   	push   %edi
    15dc:	56                   	push   %esi
    15dd:	e8 91 fd ff ff       	call   1373 <write>
        while(*s != 0){
    15e2:	0f b6 03             	movzbl (%ebx),%eax
    15e5:	83 c4 10             	add    $0x10,%esp
    15e8:	84 c0                	test   %al,%al
    15ea:	75 e4                	jne    15d0 <printf+0x110>
      state = 0;
    15ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    15ef:	31 c9                	xor    %ecx,%ecx
    15f1:	e9 1c ff ff ff       	jmp    1512 <printf+0x52>
    15f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    1600:	83 ec 0c             	sub    $0xc,%esp
    1603:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1608:	6a 01                	push   $0x1
    160a:	e9 7b ff ff ff       	jmp    158a <printf+0xca>
    160f:	90                   	nop
        putc(fd, *ap);
    1610:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1613:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1616:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1618:	6a 01                	push   $0x1
    161a:	57                   	push   %edi
    161b:	56                   	push   %esi
        putc(fd, *ap);
    161c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    161f:	e8 4f fd ff ff       	call   1373 <write>
        ap++;
    1624:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1628:	83 c4 10             	add    $0x10,%esp
      state = 0;
    162b:	31 c9                	xor    %ecx,%ecx
    162d:	e9 e0 fe ff ff       	jmp    1512 <printf+0x52>
    1632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1638:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    163b:	83 ec 04             	sub    $0x4,%esp
    163e:	e9 2a ff ff ff       	jmp    156d <printf+0xad>
    1643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1647:	90                   	nop
          s = "(null)";
    1648:	ba bf 18 00 00       	mov    $0x18bf,%edx
        while(*s != 0){
    164d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1650:	b8 28 00 00 00       	mov    $0x28,%eax
    1655:	89 d3                	mov    %edx,%ebx
    1657:	e9 74 ff ff ff       	jmp    15d0 <printf+0x110>
    165c:	66 90                	xchg   %ax,%ax
    165e:	66 90                	xchg   %ax,%ax

00001660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1661:	a1 14 1c 00 00       	mov    0x1c14,%eax
{
    1666:	89 e5                	mov    %esp,%ebp
    1668:	57                   	push   %edi
    1669:	56                   	push   %esi
    166a:	53                   	push   %ebx
    166b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    166e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1678:	89 c2                	mov    %eax,%edx
    167a:	8b 00                	mov    (%eax),%eax
    167c:	39 ca                	cmp    %ecx,%edx
    167e:	73 30                	jae    16b0 <free+0x50>
    1680:	39 c1                	cmp    %eax,%ecx
    1682:	72 04                	jb     1688 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1684:	39 c2                	cmp    %eax,%edx
    1686:	72 f0                	jb     1678 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1688:	8b 73 fc             	mov    -0x4(%ebx),%esi
    168b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    168e:	39 f8                	cmp    %edi,%eax
    1690:	74 30                	je     16c2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1692:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1695:	8b 42 04             	mov    0x4(%edx),%eax
    1698:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    169b:	39 f1                	cmp    %esi,%ecx
    169d:	74 3a                	je     16d9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    169f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    16a1:	5b                   	pop    %ebx
  freep = p;
    16a2:	89 15 14 1c 00 00    	mov    %edx,0x1c14
}
    16a8:	5e                   	pop    %esi
    16a9:	5f                   	pop    %edi
    16aa:	5d                   	pop    %ebp
    16ab:	c3                   	ret    
    16ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16b0:	39 c2                	cmp    %eax,%edx
    16b2:	72 c4                	jb     1678 <free+0x18>
    16b4:	39 c1                	cmp    %eax,%ecx
    16b6:	73 c0                	jae    1678 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    16b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    16be:	39 f8                	cmp    %edi,%eax
    16c0:	75 d0                	jne    1692 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    16c2:	03 70 04             	add    0x4(%eax),%esi
    16c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    16c8:	8b 02                	mov    (%edx),%eax
    16ca:	8b 00                	mov    (%eax),%eax
    16cc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    16cf:	8b 42 04             	mov    0x4(%edx),%eax
    16d2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    16d5:	39 f1                	cmp    %esi,%ecx
    16d7:	75 c6                	jne    169f <free+0x3f>
    p->s.size += bp->s.size;
    16d9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    16dc:	89 15 14 1c 00 00    	mov    %edx,0x1c14
    p->s.size += bp->s.size;
    16e2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    16e5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    16e8:	89 0a                	mov    %ecx,(%edx)
}
    16ea:	5b                   	pop    %ebx
    16eb:	5e                   	pop    %esi
    16ec:	5f                   	pop    %edi
    16ed:	5d                   	pop    %ebp
    16ee:	c3                   	ret    
    16ef:	90                   	nop

000016f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16f0:	55                   	push   %ebp
    16f1:	89 e5                	mov    %esp,%ebp
    16f3:	57                   	push   %edi
    16f4:	56                   	push   %esi
    16f5:	53                   	push   %ebx
    16f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    16fc:	8b 3d 14 1c 00 00    	mov    0x1c14,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1702:	8d 70 07             	lea    0x7(%eax),%esi
    1705:	c1 ee 03             	shr    $0x3,%esi
    1708:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    170b:	85 ff                	test   %edi,%edi
    170d:	0f 84 9d 00 00 00    	je     17b0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1713:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1715:	8b 4a 04             	mov    0x4(%edx),%ecx
    1718:	39 f1                	cmp    %esi,%ecx
    171a:	73 6a                	jae    1786 <malloc+0x96>
    171c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1721:	39 de                	cmp    %ebx,%esi
    1723:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1726:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    172d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1730:	eb 17                	jmp    1749 <malloc+0x59>
    1732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1738:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    173a:	8b 48 04             	mov    0x4(%eax),%ecx
    173d:	39 f1                	cmp    %esi,%ecx
    173f:	73 4f                	jae    1790 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1741:	8b 3d 14 1c 00 00    	mov    0x1c14,%edi
    1747:	89 c2                	mov    %eax,%edx
    1749:	39 d7                	cmp    %edx,%edi
    174b:	75 eb                	jne    1738 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    174d:	83 ec 0c             	sub    $0xc,%esp
    1750:	ff 75 e4             	push   -0x1c(%ebp)
    1753:	e8 83 fc ff ff       	call   13db <sbrk>
  if(p == (char*)-1)
    1758:	83 c4 10             	add    $0x10,%esp
    175b:	83 f8 ff             	cmp    $0xffffffff,%eax
    175e:	74 1c                	je     177c <malloc+0x8c>
  hp->s.size = nu;
    1760:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1763:	83 ec 0c             	sub    $0xc,%esp
    1766:	83 c0 08             	add    $0x8,%eax
    1769:	50                   	push   %eax
    176a:	e8 f1 fe ff ff       	call   1660 <free>
  return freep;
    176f:	8b 15 14 1c 00 00    	mov    0x1c14,%edx
      if((p = morecore(nunits)) == 0)
    1775:	83 c4 10             	add    $0x10,%esp
    1778:	85 d2                	test   %edx,%edx
    177a:	75 bc                	jne    1738 <malloc+0x48>
        return 0;
  }
}
    177c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    177f:	31 c0                	xor    %eax,%eax
}
    1781:	5b                   	pop    %ebx
    1782:	5e                   	pop    %esi
    1783:	5f                   	pop    %edi
    1784:	5d                   	pop    %ebp
    1785:	c3                   	ret    
    if(p->s.size >= nunits){
    1786:	89 d0                	mov    %edx,%eax
    1788:	89 fa                	mov    %edi,%edx
    178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1790:	39 ce                	cmp    %ecx,%esi
    1792:	74 4c                	je     17e0 <malloc+0xf0>
        p->s.size -= nunits;
    1794:	29 f1                	sub    %esi,%ecx
    1796:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1799:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    179c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    179f:	89 15 14 1c 00 00    	mov    %edx,0x1c14
}
    17a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    17a8:	83 c0 08             	add    $0x8,%eax
}
    17ab:	5b                   	pop    %ebx
    17ac:	5e                   	pop    %esi
    17ad:	5f                   	pop    %edi
    17ae:	5d                   	pop    %ebp
    17af:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    17b0:	c7 05 14 1c 00 00 18 	movl   $0x1c18,0x1c14
    17b7:	1c 00 00 
    base.s.size = 0;
    17ba:	bf 18 1c 00 00       	mov    $0x1c18,%edi
    base.s.ptr = freep = prevp = &base;
    17bf:	c7 05 18 1c 00 00 18 	movl   $0x1c18,0x1c18
    17c6:	1c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    17cb:	c7 05 1c 1c 00 00 00 	movl   $0x0,0x1c1c
    17d2:	00 00 00 
    if(p->s.size >= nunits){
    17d5:	e9 42 ff ff ff       	jmp    171c <malloc+0x2c>
    17da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    17e0:	8b 08                	mov    (%eax),%ecx
    17e2:	89 0a                	mov    %ecx,(%edx)
    17e4:	eb b9                	jmp    179f <malloc+0xaf>
    17e6:	66 90                	xchg   %ax,%ax
    17e8:	66 90                	xchg   %ax,%ax
    17ea:	66 90                	xchg   %ax,%ax
    17ec:	66 90                	xchg   %ax,%ax
    17ee:	66 90                	xchg   %ax,%ax

000017f0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    17f0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    17f1:	b9 01 00 00 00       	mov    $0x1,%ecx
    17f6:	89 e5                	mov    %esp,%ebp
    17f8:	8b 55 08             	mov    0x8(%ebp),%edx
    17fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    17ff:	90                   	nop
    1800:	89 c8                	mov    %ecx,%eax
    1802:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1805:	85 c0                	test   %eax,%eax
    1807:	75 f7                	jne    1800 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1809:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    180e:	5d                   	pop    %ebp
    180f:	c3                   	ret    

00001810 <urelease>:

void urelease (struct uspinlock *lk) {
    1810:	55                   	push   %ebp
    1811:	89 e5                	mov    %esp,%ebp
    1813:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1816:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    181b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1821:	5d                   	pop    %ebp
    1822:	c3                   	ret    
