 
--蓬莱-不死之烟 藤原妹红
function c21077.initial_effect(c)
	--tribute check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c21077.valcheck)
	c:RegisterEffect(e0)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21077,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c21077.ntcon)
	e1:SetOperation(c21077.ntop)
	c:RegisterEffect(e1)
	--summon with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21077,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c21077.otcon)
	e2:SetOperation(c21077.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	--act
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21077,4))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c21077.condition)
	e3:SetTarget(c21077.target)
	e3:SetOperation(c21077.operation)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21077,6))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c21077.sptg)
	e5:SetOperation(c21077.spop)
	c:RegisterEffect(e5)
end
function c21077.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(aux.TRUE,nil)
	e:SetLabel(ct)
end
function c21077.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c21077.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1800)
	c:RegisterEffect(e1)
end
function c21077.otcon(e,c)
	if c==nil then return true end
	local g=Duel.GetTributeGroup(c)
	return c:GetLevel()>6 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and g:IsExists(Card.IsSetCard,1,nil,0x208)
end
function c21077.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x208)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c21077.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)-- and e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c21077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct = 0
	if e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE then
		ct=e:GetLabelObject():GetLabel()
	else
		ct=e:GetHandler():GetFlagEffect(210770)*2
	end
	local opt = 0
	local sopt = 0
	local select = {}
	select[1] = 0
	select[2] = 0
	local b1=Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	if chk==0 then return ct>0 and (b1 or b2) end
	
	if  b1 and b2 then 
		opt = 1 + Duel.SelectOption(tp,aux.Stringid(21077,2),aux.Stringid(21077,3))
		select[opt] = 1
		ct = ct - 1
		if opt == 2 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(21077,5)) and Duel.SelectOption(tp,aux.Stringid(21077,2)) then select[1] = 1 end
		if opt == 1 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(21077,5)) and Duel.SelectOption(tp,aux.Stringid(21077,3)) then select[2] = 1 end
	else
		if b1 and not b2 and Duel.SelectOption(tp,aux.Stringid(21077,2)) then select[1] = 1 end
		if not b1 and b2 and Duel.SelectOption(tp,aux.Stringid(21077,3)) then select[2] = 1 end
	end
	
	if select[1] == 1 then
		sopt = sopt + 1
		local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local atk=g:GetFirst():GetAttack()
		if atk<0 then atk=0 end
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
	end
	
	if select[2] == 1 then
		sopt = sopt + 2
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
	
	e:SetLabel(sopt)
end
function c21077.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	
	if bit.band(ct,1) == 1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local atk=tc:GetAttack()
			if atk<0 then atk=0 end
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.Damage(1-tp,atk/2,REASON_EFFECT)
			end
		end
	end
	
	if bit.band(ct,2) == 2 then
		if c:IsRelateToEffect(e) then
			c:RegisterFlagEffect(21077,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end

end
function c21077.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(21077)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21077.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
