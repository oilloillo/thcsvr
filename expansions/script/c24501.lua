--恋与意识的连结✿古明地恋
function c24501.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--link immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c24501.condition)
	e1:SetTarget(c24501.tgtg)
	e1:SetValue(c24501.efilter)
	c:RegisterEffect(e1)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c24501.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c24501.condition)
	e3:SetValue(c24501.efilter)
	c:RegisterEffect(e3)
	--rose
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24501,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c24501.drcon)
	e4:SetTarget(c24501.target)
	e4:SetOperation(c24501.operation)
	c:RegisterEffect(e4)
end
function c24501.rosefilter(c)
	return c:IsCode(24111) and c:IsFaceup()
end
function c24501.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(c24501.rosefilter,1,nil)
end
function c24501.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c24501.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c24501.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c24501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c24501.chainlimit)
end
function c24501.chainlimit(e,rp,tp)
	return tp==rp
end
function c24501.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rose=Duel.CreateToken(tp,24111)
	Duel.MoveToField(rose,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	rose:CancelToGrave()
	if Duel.Equip(tp,rose,c,false) then
		e:SetLabelObject(rose)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c24501.eqlimit)
		rose:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetReset(RESET_EVENT+0x17e0000)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(LOCATION_HAND)
		rose:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1020000)
		e2:SetOperation(c24501.drop)
		rose:RegisterEffect(e2)
	end
end
function c24501.eqlimit(e,c)
	return e:GetOwner()==c
end
function c24501.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,24111)
	Duel.Draw(tp,1,REASON_EFFECT)
end
