--守护与被守护的大轮✿云居一轮
function c26106.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SetCard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e1:SetValue(0x251)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26106.sccon)
	e2:SetTarget(c26106.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26106,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,26106)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c26106.sptg)
	e3:SetOperation(c26106.spop)
	c:RegisterEffect(e3)
	local e7=e3:Clone()
	e7:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e7)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(c26106.tg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26106,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c26106.eqcon)
	e5:SetTarget(c26106.eqtg)
	e5:SetOperation(c26106.eqop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26106,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c26106.target)
	e6:SetOperation(c26106.operation)
	c:RegisterEffect(e6)
end
function c26106.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or tc:GetOriginalAttribute()==e:GetHandler():GetOriginalAttribute()
end
function c26106.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c26106.spfilter(c)
	return c:IsSetCard(0x251b) and c:IsFaceup()
end
function c26106.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26106.filter(chkc) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26106.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26106.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SKIP_BP)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetCondition(c26106.skipcon)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c26106.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c26106.tg(e,c)
	return c:IsSetCard(0x251b)
end
function c26106.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x251b)
end
function c26106.eqcon(e)
	return not e:GetHandler():GetEquipGroup():IsExists(c26106.eqfilter,1,nil)
end
function c26106.filter(c)
	return c:IsSetCard(0x251b)
end
function c26106.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c26106.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
end
function c26106.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c26106.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c26106.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c26106.eqlimit(e,c)
	return e:GetOwner()==c
end
function c26106.eqqfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x251b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	local sg=g:Filter(c26106.eqqfilter,nil,e,tp)
	if chk==0 then return sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg:GetFirst(),1,0,0)
end
function c26106.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetEquipGroup()
	local sg=g:Filter(c26106.eqqfilter,nil,e,tp)
	if sg:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local tc=sg:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
end
