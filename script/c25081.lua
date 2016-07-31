 
--面灵气✿秦心
function c25081.initial_effect(c)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(c25081.efilter)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25081,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c25081.settg)
	e2:SetOperation(c25081.setop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c25081.synlimit)
	c:RegisterEffect(e4)
end
function c25081.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x223)
end
function c25081.efilter(e,te)
	return te:IsActiveType(TYPE_EQUIP)
end
function c25081.tcfilter(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c25081.filter(c)
	return c:IsSetCard(0x414) and Duel.IsExistingMatchingCard(c25081.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c25081.eqfilter(c,code)
	return c:IsCode(code)
end
function c25081.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(25129) and not c:IsDisabled()
end
function c25081.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local cs=e:GetHandler():GetFlagEffect(25081)
		if Duel.IsExistingMatchingCard(c25081.cfilter,tp,LOCATION_SZONE,0,1,nil) then
			return cs<2
				and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
				and Duel.IsExistingMatchingCard(c25081.filter,tp,LOCATION_DECK,0,1,nil)
		else 
			return cs==0
				and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
				and Duel.IsExistingMatchingCard(c25081.filter,tp,LOCATION_DECK,0,1,nil)
		end
	end
	e:GetHandler():RegisterFlagEffect(25081,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c25081.setop(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if lc<=0 then return end
	local g=Duel.GetMatchingGroup(c25081.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25081,1))
	local sg=g:Select(tp,1,1,nil)
	local sc = sg:GetFirst()
	local code=sc:GetCode()
	local equitg=Duel.GetMatchingGroup(c25081.eqfilter,tp,LOCATION_DECK,0,nil,code)
	local monsterg=Duel.GetMatchingGroup(c25081.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,sc)
	local equitc=equitg:GetCount()
	local monsterc=monsterg:GetCount()
	if equitc > monsterc then equitc = monsterc end
	if equitc > lc then equitc = lc end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25081,2))
	local smg=Duel.SelectMatchingCard(tp,c25081.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,equitc,equitc,nil,sc)	
	Duel.Equip(tp,equitg:GetFirst(),smg:GetFirst())
	equitc = equitc - 1
	while(equitc>0) do
		Duel.Equip(tp,equitg:GetNext(),smg:GetNext())
		equitc = equitc - 1
	end
end
