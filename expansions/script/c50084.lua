 
--轻型航空母舰-龙骧
function c50084.initial_effect(c)
	local temp = 0
	while temp<4 do
		c:RegisterFlagEffect(50900,0,0,0)
		temp = temp+1
	end
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50084.spcon)
	c:RegisterEffect(e2)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c50084.xyzlimit)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_DECK)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--lvup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(50084,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c50084.cost)
	e6:SetTarget(c50084.lvtg)
	e6:SetOperation(c50084.lvop)
	c:RegisterEffect(e6)
	--equip
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetDescription(aux.Stringid(50084,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c50084.cost)
	e7:SetTarget(c50084.eqtg)
	e7:SetOperation(c50084.eqop)
	c:RegisterEffect(e7)
end
function c50084.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c50084.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x4bb)
end
function c50084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c50084.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(500840)==0 end
	e:GetHandler():RegisterFlagEffect(500840,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50084.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c50084.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x91c)
end
function c50084.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetFlagEffect(500840)==0
		and Duel.IsExistingMatchingCard(c50084.filter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(500840,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50084.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c50084.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
