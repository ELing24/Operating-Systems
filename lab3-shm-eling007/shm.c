#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
	//look over shm_table
	
	int i;
	int exist = 0;
	acquire(&(shm_table.lock));
	for(i = 0; i < 64; i++){
		struct shm_page *page = &shm_table.shm_pages[i];
		if(id == page->id)
		{

			exist = 1;
			page->refcnt++;
			if(mappages(myproc()->pgdir, (char *)PGROUNDUP(myproc()->sz), PGSIZE,V2P(page->frame), PTE_W|PTE_U) < 0){
				release(&(shm_table.lock));
				return -1;
			}
			break;	
			
		}
	}
	if(!exist){
		for(i = 0; i < 64; i++)
		{
			struct shm_page *page = &shm_table.shm_pages[i];
			if(page->id == 0){
				page->id = id;
				page->frame = kalloc();
				page->refcnt = 1;
				memset(page->frame, 0 , PGSIZE);
				if(mappages(myproc()->pgdir, (char *)PGROUNDUP(myproc()->sz), PGSIZE, V2P(page->frame), PTE_W|PTE_U) < 0){
					release((&shm_table.lock));
					return -1;	
				}
				break;
			}
		}
	}

	*pointer = (char *)PGROUNDUP(myproc()->sz);
	myproc()->sz += PGSIZE;
	release(&(shm_table.lock));

return 0; //added to remove compiler warning -- you should decide what to return
}


// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.

static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

int shm_close(int id) {
//you write this too!
	int i;
	int match = 0;
	acquire(&(shm_table.lock));
	for(i = 0; i < 64; ++i){
		struct shm_page *page = &shm_table.shm_pages[i];
		if(id == page->id){
			match = 1;
			page->refcnt--;
			if(page->refcnt > 0){
				break;
			}else{
				page->frame = 0;
				page->id = 0;
				pte_t *pte = walkpgdir(myproc()->pgdir, (void *) myproc()->sz - PGSIZE, 0);
				*pte = 0;
				break;
			}
		
		}
	}
	release(&(shm_table.lock));
	if(!match){
		return 1;
	}
	


return 0; //added to remove compiler warning -- you should decide what to return
}

